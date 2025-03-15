#!/bin/bash

# Configuratie
RESTIC_REPOSITORY="/path/to/your/restic/repository"
RESTIC_PASSWORD_FILE="/path/to/your/restic/password.txt"
SOURCE_DIR="/path/to/source"          # De map die je wilt back-uppen
BACKUP_DIR="/path/to/backup"          # Lokale back-upmap (alleen als je dat wilt)
RCLONE_REMOTE="your-remote-name:/backup"  # Rclone remote configuratie
RCLONE_LOG="/path/to/rclone_log.txt"   # Logbestand voor Rclone
BACKUP_RETENTION_DAYS=30              # Hoeveel dagen je back-ups wilt bewaren

# E-mailinstellingen
EMAIL_RECIPIENT="your-email@example.com"
EMAIL_SENDER="sender-email@example.com"
EMAIL_SUBJECT="Back-up Status"

# Functie om een e-mailmelding te sturen
send_email_notification() {
    local subject="$1"
    local message="$2"
    echo -e "Subject:$subject\n\n$message" | sendmail -v "$EMAIL_RECIPIENT"
}

# Functie om een back-up te maken met Restic
backup_with_restic() {
    echo "We beginnen nu met de back-up van $SOURCE_DIR met Restic..."
    send_email_notification "$EMAIL_SUBJECT" "We beginnen met de back-up van $SOURCE_DIR met Restic..."

    # Laad het wachtwoordbestand voor Restic
    export RESTIC_PASSWORD=$(cat "$RESTIC_PASSWORD_FILE")

    # Voer de back-up uit
    restic -r "$RESTIC_REPOSITORY" backup "$SOURCE_DIR" --exclude-caches --quiet
    if [ $? -eq 0 ]; then
        echo "Restic back-up is geslaagd!"
        send_email_notification "$EMAIL_SUBJECT" "Restic back-up is voltooid voor $SOURCE_DIR."
    else
        echo "Oeps, de Restic back-up is mislukt!" >&2
        send_email_notification "$EMAIL_SUBJECT" "De Restic back-up is mislukt voor $SOURCE_DIR!"
        exit 1
    fi
}

# Functie om oude back-ups te verwijderen die te lang bewaard zijn
cleanup_old_backups() {
    echo "We gaan nu oude back-ups opruimen die ouder zijn dan $BACKUP_RETENTION_DAYS dagen..."
    send_email_notification "$EMAIL_SUBJECT" "We gaan oude back-ups opruimen die ouder zijn dan $BACKUP_RETENTION_DAYS dagen..."

    # Verwijder oude back-ups
    restic -r "$RESTIC_REPOSITORY" forget --prune --keep-last 1 --keep-daily "$BACKUP_RETENTION_DAYS" --quiet
    if [ $? -eq 0 ]; then
        echo "Oude back-ups zijn succesvol opgeruimd!"
        send_email_notification "$EMAIL_SUBJECT" "Oude back-ups zijn succesvol opgeruimd."
    else
        echo "Er is iets mis gegaan bij het opruimen van oude back-ups!" >&2
        send_email_notification "$EMAIL_SUBJECT" "Fout bij het opruimen van oude back-ups!"
        exit 1
    fi
}

# Functie om de back-up naar de cloud te uploaden met Rclone
upload_to_cloud() {
    echo "We gaan de back-up nu naar de cloud uploaden via Rclone..."
    send_email_notification "$EMAIL_SUBJECT" "We beginnen met het uploaden van de back-up naar de cloud via Rclone..."

    # Upload de back-up naar de cloud
    rclone sync "$RESTIC_REPOSITORY" "$RCLONE_REMOTE" --log-file="$RCLONE_LOG" --log-level INFO
    if [ $? -eq 0 ]; then
        echo "De back-up is succesvol geüpload naar de cloud!"
        send_email_notification "$EMAIL_SUBJECT" "De back-up is succesvol geüpload naar de cloud."
    else
        echo "Oeps, het uploaden naar de cloud is mislukt!" >&2
        send_email_notification "$EMAIL_SUBJECT" "Upload naar de cloud mislukt!"
        exit 1
    fi
}

# Functie die alles in één keer doet: back-up maken, opruimen, en uploaden
perform_backup() {
    backup_with_restic
    cleanup_old_backups
    upload_to_cloud
}

# Hoofdscript
echo "We starten nu het back-upscript..."
send_email_notification "$EMAIL_SUBJECT" "We starten het back-upscript..."
perform_backup
echo "De back-up is voltooid."
send_email_notification "$EMAIL_SUBJECT" "De back-up is voltooid."
