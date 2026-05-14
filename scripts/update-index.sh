#!/bin/bash
# Regenerate search-index.json from editions.json
# Reads each article's first paragraph as excerpt

set -e
cd "$(dirname "$0")/../docs"

echo '[' > search-index.json
first=true

python3 -c "
import json

with open('editions.json') as f:
    data = json.load(f)

entries = []
for e in data['editions']:
    slug = e['slug']
    entry = {
        'slug': slug,
        'slug_en': e.get('slug_en', slug),
        'date': e['date'],
        'dateDisplay': e['dateDisplay'],
        'title': e['title'],
        'title_en': e.get('title_en', ''),
        'tags': e.get('tags', []),
        'tags_en': e.get('tags_en', []),
        'excerpt': '',
        'excerpt_en': '',
    }
    # Extract first paragraph from .md
    for lang, key in [('md', 'excerpt'), ('en.md', 'excerpt_en')]:
        try:
            with open(f'issues/{slug}.{lang}') as f:
                body = f.read().split('---\n')[-1].strip()
                for line in body.split('\n'):
                    clean = line.strip()
                    if clean and not clean.startswith('##') and not clean.startswith('>') and not clean.startswith('|'):
                        entry[key] = clean[:200]
                        break
        except:
            pass
    entries.append(entry)

with open('search-index.json', 'w') as f:
    json.dump(entries, f, ensure_ascii=False, indent=2)

print(f'Updated search-index.json: {len(entries)} entries')
"
