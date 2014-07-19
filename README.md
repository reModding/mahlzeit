mahlzeit
========

Voraussetzungen
---------------

- Ruby 2.0
  - YAML-Support


Installation
------------

```bash
git clone ...
cd mahlzeit/
for file in *.dist; do cp "$file" "$(basename $file .dist)"; done
vim mahlzeitbot.yml
chmod +x mahlzeitbot.rb
./mahlzeitbot.rb
```
