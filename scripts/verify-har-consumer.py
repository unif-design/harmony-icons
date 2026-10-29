#!/usr/bin/env python3
"""Validate the built HAR and compile an isolated consumer of every public icon."""
import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess
import tarfile
import tempfile


def main():
    root = Path(__file__).resolve().parents[1]
    artifact = root / 'library/build/default/outputs/default/library.har'
    public_names = re.findall(r'^export \{ (\w+(?:Outlined|Filled)) \}',
                              (root / 'library/Index.ets').read_text(), re.M)
    assert public_names and len(public_names) == len(set(public_names))
    source_package = json.loads((root / 'library/oh-package.json5').read_text())
    source_provenance = json.loads((root / 'library/src/main/resources/rawfile/icon-provenance.json').read_text())
    with tarfile.open(artifact) as archive:
        def read(name):
            entry = archive.extractfile('package/' + name)
            assert entry is not None, name
            return entry.read()

        package = json.loads(read('oh-package.json5'))
        assert package['name'] == '@unif/harmony-icons'
        assert package['version'] == source_package['version']
        assert package['dependencies'] == {}
        assert len(read('ets/modules.abc')) > 0
        declarations = read('Index.d.ets').decode()
        assert '/Users/' not in declarations
        provenance = json.loads(read('src/main/resources/rawfile/icon-provenance.json'))
        assert provenance == source_provenance, 'HAR is stale; rebuild from the checked source'
        assert sorted(icon['component'] for icon in provenance['icons']) == sorted(public_names)
        for name in public_names:
            assert f'export {{ {name} }}' in declarations, name
            assert read(f'src/main/ets/generated/{name}.d.ets'), name

    consumer = Path(tempfile.mkdtemp(prefix='unif-icons-har-consumer-'))
    for name in ['AppScope', 'hvigor', 'example']:
        shutil.copytree(root / name, consumer / name,
                        ignore=shutil.ignore_patterns('build', 'oh_modules', 'oh-package-lock.json5'))
    for name in ['hvigorfile.ts', 'oh-package.json5']:
        shutil.copy2(root / name, consumer / name)
    profile = json.loads((root / 'build-profile.json5').read_text())
    profile['modules'] = [item for item in profile['modules'] if item['name'] == 'example']
    (consumer / 'build-profile.json5').write_text(json.dumps(profile, indent=2) + '\n')
    (consumer / 'packages').mkdir()
    shutil.copy2(artifact, consumer / 'packages/harmony-icons.har')
    package_file = consumer / 'example/oh-package.json5'
    host_package = json.loads(package_file.read_text())
    host_package['dependencies'] = {'@unif/harmony-icons': 'file:../packages/harmony-icons.har'}
    package_file.write_text(json.dumps(host_package, indent=2) + '\n')
    (consumer / 'example/src/main/ets/pages/AllNamedIcons.ets').write_text(
        "import { " + ', '.join(public_names) + " } from '@unif/harmony-icons';\n\n"
        '@ComponentV2\nexport struct AllNamedIcons {\n  build() {\n    Column() {\n' +
        ''.join(f'      {name}()\n' for name in public_names) + '    }\n  }\n}\n')
    page = consumer / 'example/src/main/ets/pages/Index.ets'
    page.write_text("import { AllNamedIcons } from './AllNamedIcons';\n" +
                    page.read_text().replace('Column({ space: 12 }) {',
                                             'Column({ space: 12 }) {\n      AllNamedIcons()', 1))
    print(f'Isolated consumer: {consumer}', flush=True)
    print(f'HAR SHA-256: {hashlib.sha256(artifact.read_bytes()).hexdigest()}', flush=True)
    subprocess.run(['devecocli', 'build', '--modules', 'example', '--build-mode', 'debug'],
                   cwd=consumer, check=True)
    hap = consumer / 'example/build/default/outputs/default/example-default-unsigned.hap'
    assert hap.is_file() and hap.stat().st_size > 0
    print(f'{len(public_names)} named components and generic entry compiled from HAR: {hap}')
    print('Build evidence only; no device installation or visual/accessibility acceptance.')


if __name__ == '__main__':
    main()
