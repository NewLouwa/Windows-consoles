#English
# Windows Console Manager

A simple graphical interface in Python to manage and launch Windows consoles (MMC tools). This program is designed for system administrators and divides the consoles into two categories:
- **Server Consoles**: To manage tools specific to Windows servers.
- **Client Consoles**: To manage tools related to user workstations.

## Features

- **Console Display**: Consoles are listed in a table format with three columns:
  - **Name**: Displays the console name for quick identification.
  - **Command**: The corresponding MMC command (e.g., `compmgmt.msc`).
  - **Description**: Briefly explains the utility or main function of the console.
- **Console Launch**: Select a console and click **Launch** to execute it.
- **Distinct Categories**: Two separate sections for Server and Client consoles.

---

## Installation

### Prerequisites

- Python 3.6 or higher.
- The `tkinter` module (included by default with Python on Windows).

### Download

1. Clone this repository or download the `console_manager.py` file:
   ```bash
   git clone https://github.com/your-username/console-manager-windows.git
   cd console-manager-windows
   ```

2. Install dependencies (if needed):
   ```bash
   pip install -r requirements.txt
   ```
   (No additional modules are required by default since the program uses `tkinter` and `subprocess`.)

---

## Usage

1. Run the program with Python:
   ```bash
   python console_manager.py
   ```

2. A window will open with two sections:
   - **Server Consoles**: Displays MMC tools for server management.
   - **Client Consoles**: Displays MMC tools for user workstations.

3. Select a console from the table and click **Launch** to execute it.

---

## Adding New Consoles

### Step 1: Modify the Code

To add a new console:

1. Open the `console_manager.py` file.
2. Add the console to either the `server_consoles` or `client_consoles` list using the following format (these lists are defined in the global variables section at the beginning of the `console_manager.py` file):
   ```python
   {"name": "Console Name", "command": "command.msc", "description": "Description of the console."}
   ```

### Example Addition

If you want to add a console for managing printers in the Server category, add this entry to `server_consoles`:
```python
server_consoles.append(
    {"name": "Print Management", "command": "printmanagement.msc", "description": "Manages printers and print queues."}
)
```

---

## Technical Details

1. **Console Lists**:
   - The consoles are organized into two Python lists:

```python
server_consoles = [
    {"name": "Active Directory Users and Computers", "command": "dsa.msc", "description": "Manages Active Directory users and computers."},
    {"name": "DNS Manager", "command": "dnsmgmt.msc", "description": "Manages DNS zones and records."}
]

client_consoles = [
    {"name": "Computer Management", "command": "compmgmt.msc", "description": "Combines multiple administrative tools."},
    {"name": "Device Manager", "command": "devmgmt.msc", "description": "Manages hardware devices and drivers."}
]
```
   - `server_consoles`: For Server tools.
   - `client_consoles`: For Client tools.

2. **Graphical Interface with Tkinter**:
   - Uses `Treeview` to display consoles in a table format.
   - The tables have three columns: Name, Command, Description.

3. **Launching Consoles**:
   - When a console is selected, the program uses `subprocess.run()` to execute the corresponding MMC command. If an error occurs during execution, an error dialog is displayed to inform the user.

---

## Contributing

If you want to contribute:

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/console-manager-windows.git
   ```
2. Create a branch for your changes:

Example branch name: `feature/new-console` to add a feature or `fix/console-launch-bug` to fix a problem.
   ```bash
   git checkout -b new-feature
   ```
3. Submit a Pull Request with your changes.

---

## License

This project is licensed under the [MIT](LICENSE) license. You are free to use, modify, and distribute it under the terms of the license.




#FRench

# Gestionnaire de Consoles Windows

Une interface graphique simple en Python pour gérer et lancer les consoles Windows (outils MMC). Ce programme est conçu pour les administrateurs systèmes et divise les consoles en deux catégories :
- **Consoles Serveur** : Pour gérer les outils spécifiques aux serveurs Windows.
- **Consoles Client** : Pour gérer les outils liés aux postes utilisateurs.

## Fonctionnalités

- **Affichage des consoles** : Les consoles sont listées sous forme de tableau avec trois colonnes :
- **Nom** : Affiche le nom de la console pour une identification rapide.
- **Commande** : La commande MMC correspondante (par exemple, `compmgmt.msc`).
- **Description** : Explique brièvement l’utilité ou la fonction principale de la console.
  - Le nom de la console.
  - La commande associée (`*.msc`).
  - Une description de son utilité.
- **Lancement des consoles** : Sélectionnez une console et cliquez sur **Lancer** pour l'exécuter.
- **Catégories distinctes** : Deux sections distinctes pour les consoles Serveur et Client.

---

## Installation

### Prérequis

- Python 3.6 ou supérieur.
- Le module `tkinter` (inclus par défaut avec Python sur Windows).

### Téléchargement

1. Clonez ce dépôt ou téléchargez le fichier `console_manager.py` :
   ```bash
   git clone https://github.com/votre-utilisateur/console-manager-windows.git
   cd console-manager-windows
   ```

2. Installez les dépendances (si nécessaire) :
   ```bash
   pip install -r requirements.txt
   ```
   (Aucun module supplémentaire n’est requis par défaut, car le programme utilise `tkinter` et `subprocess`.)

---

## Utilisation

1. Lancez le programme avec Python :
   ```bash
   python console_manager.py
   ```

2. Une fenêtre s’ouvre avec deux sections :
   - **Consoles Serveur** : Affiche les outils MMC pour la gestion des serveurs.
   - **Consoles Client** : Affiche les outils MMC pour les postes utilisateurs.

3. Sélectionnez une console dans le tableau et cliquez sur **Lancer** pour l'exécuter.

---

## Ajouter de nouvelles consoles

### Étape 1 : Modifier le code

Pour ajouter une nouvelle console :

1. Ouvrez le fichier `console_manager.py`.
2. Ajoutez la console dans la liste `server_consoles` ou `client_consoles` en respectant le format suivant (ces listes sont définies dans la section des variables globales, au début du fichier `console_manager.py`) :
   ```python
   {"name": "Nom de la Console", "command": "commande.msc", "description": "Description de la console."}
   ```

### Exemple d'ajout

Si vous souhaitez ajouter une console pour gérer les imprimantes dans la catégorie Serveur, ajoutez cet élément à `server_consoles` :
```python
server_consoles.append(
    {"name": "Gestion des Imprimantes", "command": "printmanagement.msc", "description": "Gère les imprimantes et les files d'attente."}
)
```

---

## Fonctionnement technique

1. **Listes des consoles** :
   - Les consoles sont organisées dans deux listes Python :

```python
server_consoles = [
    {"name": "Active Directory Users and Computers", "command": "dsa.msc", "description": "Gère les utilisateurs et ordinateurs AD."},
    {"name": "DNS Manager", "command": "dnsmgmt.msc", "description": "Gère les zones et enregistrements DNS."}
]

client_consoles = [
    {"name": "Computer Management", "command": "compmgmt.msc", "description": "Regroupe plusieurs outils d’administration."},
    {"name": "Device Manager", "command": "devmgmt.msc", "description": "Gère les périphériques et pilotes matériels."}
]
```
     - `server_consoles` : Pour les outils Serveur.
     - `client_consoles` : Pour les outils Client.

2. **Interface graphique avec Tkinter** :
   - Utilise `Treeview` pour afficher les consoles sous forme de tableau.
   - Les tableaux ont trois colonnes : Nom, Commande, Description.

3. **Lancement des consoles** :
   - Lorsqu'une console est sélectionnée, le programme utilise `subprocess.run()` pour exécuter la commande MMC associée. Si une erreur se produit lors de l'exécution, une boîte de dialogue d'erreur s'affiche pour informer l'utilisateur.

---

## Contribuer

Si vous souhaitez contribuer :

1. Clonez le dépôt :
   ```bash
   git clone https://github.com/votre-utilisateur/console-manager-windows.git
   ```
2. Créez une branche pour vos modifications :

Exemple de nom de branche : `feature/new-console` pour ajouter une fonctionnalité ou `fix/console-launch-bug` pour corriger un problème.
   ```bash
   git checkout -b nouvelle-fonctionnalite
   ```
3. Envoyez une Pull Request avec vos changements.

---

## Licence

Ce projet est sous licence [MIT](LICENSE). Vous êtes libre de l'utiliser, de le modifier et de le distribuer selon les termes de la licence.

