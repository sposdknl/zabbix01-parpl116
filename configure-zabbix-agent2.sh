#!/usr/bin/env bash

# Nastavení pevného hostname podle jména uživatele
SHORT_HOSTNAME="ubuntu-martineka"

# Záloha původní konfigurace
sudo cp -v /etc/zabbix/zabbix_agent2.conf /etc/zabbix/zabbix_agent2.conf-orig

# Úpravy konfigurace Zabbix agenta 2
sudo sed -i "s/^# Hostname=.*/Hostname=$SHORT_HOSTNAME/" /etc/zabbix/zabbix_agent2.conf
sudo sed -i "s/^Hostname=.*/Hostname=$SHORT_HOSTNAME/" /etc/zabbix/zabbix_agent2.conf
sudo sed -i 's/^Server=.*/Server=enceladus.pfsense.cz/' /etc/zabbix/zabbix_agent2.conf
sudo sed -i 's/^ServerActive=.*/ServerActive=enceladus.pfsense.cz/' /etc/zabbix/zabbix_agent2.conf
sudo sed -i 's/^# HostMetadata=.*/HostMetadata=SPOS/' /etc/zabbix/zabbix_agent2.conf
sudo sed -i 's/^# Timeout=3/Timeout=30/' /etc/zabbix/zabbix_agent2.conf

# Pokud v souboru chybí Hostname nebo HostMetadata, přidej je na konec
grep -q "^Hostname=" /etc/zabbix/zabbix_agent2.conf || echo "Hostname=$SHORT_HOSTNAME" | sudo tee -a /etc/zabbix/zabbix_agent2.conf
grep -q "^HostMetadata=" /etc/zabbix/zabbix_agent2.conf || echo "HostMetadata=SPOS" | sudo tee -a /etc/zabbix/zabbix_agent2.conf

# Porovnání pro kontrolu
sudo diff -u /etc/zabbix/zabbix_agent2.conf-orig /etc/zabbix/zabbix_agent2.conf || true

# Restart služby
sudo systemctl restart zabbix-agent2
sudo systemctl enable zabbix-agent2
