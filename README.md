mahlzeit
========

Ein kleiner IRC-Bot, welcher die gemeinsame Essensplanung erleichtern soll.


Voraussetzungen
---------------

- Ruby 2.0 (getestet)
  - YAML-Support


Installation
------------

```bash
git clone git@github.com:reModding/mahlzeit.git
cd mahlzeit/

for file in *.dist; do cp "$file" "$(basename "$file" .dist)"; done
vim mahlzeitbot.yml

chmod +x mahlzeitbot.rb
./mahlzeitbot.rb mahlzeitbot.yml
```
