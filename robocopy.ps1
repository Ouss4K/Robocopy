# Demande à l'utilisateur de saisir le chemin source
$source = Read-Host "Veuillez entrer le chemin du dossier source (ex: C:\Users\VotreNom\Downloads)"

# Vérifie si le chemin source existe
if (-Not (Test-Path -Path $source)) {
    Write-Host "Le chemin source n'existe pas. Veuillez réessayer." -ForegroundColor Red
    exit
}

# Demande à l'utilisateur de saisir le chemin destination
$destination = Read-Host "Veuillez entrer le chemin du dossier destination (ex: D:\Backup\Downloads)"

# Vérifie si le chemin destination existe
if (-Not (Test-Path -Path $destination)) {
    $create = Read-Host "Le chemin destination n'existe pas. Voulez-vous le créer? (O/N)"
    if ($create -eq "O") {
        New-Item -Path $destination -ItemType Directory
    } else {
        Write-Host "Annulation de l'opération." -ForegroundColor Yellow
        exit
    }
}

# Définir le chemin du fichier de log
$logFile = "C:\Logs\Backup.log"

# Vérifie si le dossier de log existe, sinon le crée
$logDir = Split-Path $logFile -Parent
if (-Not (Test-Path -Path $logDir)) {
    New-Item -Path $logDir -ItemType Directory
}

# Exécution de la commande Robocopy
Write-Host "Démarrage de la copie des fichiers..." -ForegroundColor Green
robocopy $source $destination /S /Z /R:5 /MT:8 /LOG:$logFile

# Vérification du résultat de la copie
if ($LASTEXITCODE -lt 8) {
    Write-Host "Copie réussie." -ForegroundColor Green
} else {
    Write-Host "Erreur lors de la copie." -ForegroundColor Red
}

# Met en pause le script
Write-Host "Appuyez sur une touche pour fermer." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
