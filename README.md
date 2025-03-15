# easyBackup met Restic en Rclone

Dit script maakt gebruik van **Restic** voor het maken van versleutelde back-ups en **Rclone** voor het uploaden van deze back-ups naar een cloudopslag. Het script is geavanceerd en flexibel, zodat je het kunt aanpassen voor jouw specifieke back-upbehoeften.

## Kenmerken:
- **Veilige versleuteling** van back-ups via Restic.
- **Automatische opruiming** van oude back-ups die ouder zijn dan een opgegeven aantal dagen.
- **Automatische upload** naar cloudopslag via Rclone (Google Drive, Dropbox, S3, enz.).
- **Volledige configuratie-opties**, zoals het opgeven van de bronmap, back-upbestemming en de cloudopslagconfiguratie.

## Voorvereisten
Zorg ervoor dat de volgende software geïnstalleerd is:

- [Restic](https://restic.readthedocs.io/en/stable/030_preparing/) - Voor het maken van versleutelde back-ups.
- [Rclone](https://rclone.org/install/) - Voor het uploaden van back-ups naar cloudopslag.

## Configuratie
1. **Installeer Restic en Rclone:**
   - Volg de installatie-instructies op de respectieve websites om zowel **Restic** als **Rclone** te installeren.

2. **Restic Configuratie:**
   - Maak een **Restic-repository** op de gewenste locatie (bijvoorbeeld een lokale schijf of cloudopslag).

3. **Rclone Configuratie:**
   - Configureer je gewenste cloudopslagprovider via Rclone (bijvoorbeeld Google Drive, Amazon S3, Dropbox).

4. **Pas het script aan:**
   - Open het script en configureer de volgende variabelen:
     - **SOURCE_DIR**: De directory die je wilt back-uppen.
     - **RESTIC_REPOSITORY**: Het pad naar je Restic-repository.
     - **RESTIC_PASSWORD_FILE**: Het bestand dat je Restic-wachtwoord bevat.
     - **RCLONE_REMOTE**: De naam van de Rclone-configuratie en het pad naar de cloudopslag.
     - **BACKUP_RETENTION_DAYS**: Het aantal dagen dat je back-ups wilt bewaren.

## Het Script Uitvoeren
1. Maak het script uitvoerbaar:
   ```bash
   chmod +x easyBackup.sh
   ```

2. Voer het script uit:
   ```bash
   ./easyBackup.sh
   ```

Het script maakt een back-up van de opgegeven map, verwijdert oude back-ups en uploadt de back-up naar de cloudopslag.

## Geavanceerde Instellingen
- **E-mailnotificaties**: Voeg e-mailmeldingen toe om op de hoogte te blijven van back-upstatussen.
- **Cronjobs**: Stel een cronjob in om het script automatisch op regelmatige tijden uit te voeren.
- **Meerdere Repositories**: Maak gebruik van verschillende Restic-repositories voor diverse gegevens.

## Licentie
Dit project is beschikbaar onder de MIT-licentie.
