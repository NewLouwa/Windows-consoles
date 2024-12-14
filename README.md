# Gestionnaire de Consoles Windows

Une interface graphique simple en Python pour gérer et lancer les consoles Windows (outils MMC). Ce programme est conçu pour les administrateurs systèmes et divise les consoles en deux catégories :
- **Consoles Serveur** : Pour gérer les outils spécifiques aux serveurs Windows.
- **Consoles Client** : Pour gérer les outils liés aux postes utilisateurs.

## Fonctionnalités

- **Affichage des consoles** : Les consoles sont listées sous forme de tableau avec :
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
2. Ajoutez la console dans la liste `server_consoles` ou `client_consoles` en respectant le format suivant :
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
     - `server_consoles` : Pour les outils Serveur.
     - `client_consoles` : Pour les outils Client.

2. **Interface graphique avec Tkinter** :
   - Utilise `Treeview` pour afficher les consoles sous forme de tableau.
   - Les tableaux ont trois colonnes : Nom, Commande, Description.

3. **Lancement des consoles** :
   - Lorsqu'une console est sélectionnée, le programme utilise `subprocess.run()` pour exécuter la commande MMC associée.

---

## Contribuer

Si vous souhaitez contribuer :

1. Clonez le dépôt :
   ```bash
   git clone https://github.com/votre-utilisateur/console-manager-windows.git
   ```
2. Créez une branche pour vos modifications :
   ```bash
   git checkout -b nouvelle-fonctionnalite
   ```
3. Envoyez une Pull Request avec vos changements.

---

## Licence

Ce projet est sous licence [MIT](LICENSE). Vous êtes libre de l'utiliser, de le modifier et de le distribuer selon les termes de la licence.

