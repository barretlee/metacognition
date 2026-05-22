#!/bin/bash
# Regenerate search-index.json and RSS feeds from editions.json
# Reads each article's first paragraph as excerpt

set -e
cd "$(dirname "$0")/../docs"

mkdir -p feed

python3 -c "
import json, os
from datetime import datetime

with open('editions.json') as f:
    data = json.load(f)

base_url = 'https://barretlee.github.io/metacognition'

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

# Write search-index.json
with open('search-index.json', 'w') as f:
    json.dump(entries, f, ensure_ascii=False, indent=2)

# Sort by date descending for RSS
entries.sort(key=lambda x: x['date'], reverse=True)

def rss_date(d):
    dt = datetime.strptime(d, '%Y-%m-%d')
    return dt.strftime('%a, %d %b %Y 00:00:00 +0800')

# Generate zh.xml
zh_items = []
for e in entries:
    title = e['title']
    link = f\"{base_url}/{e['slug_en']}\"
    desc = e['excerpt'][:500]
    date_rss = rss_date(e['date'])
    zh_items.append(f'''    <item>
      <title>{title}</title>
      <link>{link}</link>
      <description><![CDATA[{desc}]]></description>
      <pubDate>{date_rss}</pubDate>
      <guid isPermaLink=\"true\">{link}</guid>
    </item>''')

zh_xml = f'''<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<rss version=\"2.0\" xmlns:atom=\"http://www.w3.org/2005/Atom\">
  <channel>
    <title>破界期刊</title>
    <link>{base_url}</link>
    <description>认知之外，思维之疆。认知科学、哲学、投资、陌生领域，跳出思维舒适区。</description>
    <language>zh-CN</language>
    <lastBuildDate>{rss_date(entries[0]['date'])}</lastBuildDate>
    <atom:link href=\"{base_url}/feed/zh.xml\" rel=\"self\" type=\"application/rss+xml\"/>
{chr(10).join(zh_items)}
  </channel>
</rss>'''

with open('feed/zh.xml', 'w') as f:
    f.write(zh_xml)

# Generate en.xml
en_items = []
for e in entries:
    title_en = e.get('title_en', e['title'])
    link = f\"{base_url}/en/{e['slug_en']}\"
    desc = e['excerpt_en'][:500]
    date_rss = rss_date(e['date'])
    en_items.append(f'''    <item>
      <title>{title_en}</title>
      <link>{link}</link>
      <description><![CDATA[{desc}]]></description>
      <pubDate>{date_rss}</pubDate>
      <guid isPermaLink=\"true\">{link}</guid>
    </item>''')

en_xml = f'''<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<rss version=\"2.0\" xmlns:atom=\"http://www.w3.org/2005/Atom\">
  <channel>
    <title>Horizon Journal</title>
    <link>{base_url}</link>
    <description>Beyond cognition, across boundaries. Science, philosophy, investing, unfamiliar domains.</description>
    <language>en</language>
    <lastBuildDate>{rss_date(entries[0]['date'])}</lastBuildDate>
    <atom:link href=\"{base_url}/feed/en.xml\" rel=\"self\" type=\"application/rss+xml\"/>
{chr(10).join(en_items)}
  </channel>
</rss>'''

with open('feed/en.xml', 'w') as f:
    f.write(en_xml)

print(f'Updated search-index.json: {len(entries)} entries')
print(f'Updated feed/zh.xml: {len(zh_items)} items')
print(f'Updated feed/en.xml: {len(en_items)} items')
"
