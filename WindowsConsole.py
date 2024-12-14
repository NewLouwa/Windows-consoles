import os
import subprocess
import tkinter as tk
from tkinter import ttk, messagebox

# Liste des consoles Serveur
server_consoles = [
    {"name": "Active Directory Users and Computers", "command": "dsa.msc", "description": "Gère les utilisateurs et ordinateurs AD."},
    {"name": "Active Directory Domains and Trusts", "command": "domain.msc", "description": "Gère les relations d’approbation entre domaines AD."},
    {"name": "Active Directory Sites and Services", "command": "dssite.msc", "description": "Gère la réplication et la topologie AD."},
    {"name": "Group Policy Management Console", "command": "gpmc.msc", "description": "Gère les stratégies de groupe centralisées."},
    {"name": "DNS Manager", "command": "dnsmgmt.msc", "description": "Gère les zones et enregistrements DNS."},
    {"name": "DHCP Management", "command": "dhcpmgmt.msc", "description": "Gère les baux et options DHCP."},
    {"name": "AD Federation Services Console", "command": "adfs.msc", "description": "Gère les services de fédération d’identités."},
    {"name": "ADSI Edit", "command": "adsiedit.msc", "description": "Édite le schéma et les objets Active Directory."},
    {"name": "Failover Cluster Manager", "command": "cluadmin.msc", "description": "Gère les clusters de basculement."},
]

# Liste des consoles Client
client_consoles = [
    {"name": "Computer Management", "command": "compmgmt.msc", "description": "Regroupe plusieurs outils d’administration."},
    {"name": "Group Policy Management Editor", "command": "gpedit.msc", "description": "Édite les stratégies de groupe locales."},
    {"name": "Local Users and Groups", "command": "lusrmgr.msc", "description": "Gère les utilisateurs et groupes locaux."},
    {"name": "Device Manager", "command": "devmgmt.msc", "description": "Gère les périphériques et pilotes matériels."},
    {"name": "Disk Management", "command": "diskmgmt.msc", "description": "Gère les disques, partitions et volumes."},
    {"name": "Performance Monitor", "command": "perfmon.msc", "description": "Surveille les performances système."},
    {"name": "Services", "command": "services.msc", "description": "Gère les services Windows."},
    {"name": "Event Viewer", "command": "eventvwr.msc", "description": "Affiche et analyse les journaux d’événements."},
    {"name": "Certificates", "command": "certmgr.msc", "description": "Gère les certificats sur une machine."},
    {"name": "Shared Folders", "command": "fsmgmt.msc", "description": "Gère les dossiers et fichiers partagés."},
    {"name": "Hyper-V Manager", "command": "virtmgmt.msc", "description": "Gère les machines virtuelles et réseaux Hyper-V."},
]

# Fonction pour lancer une console
def launch_console(index, console_list):
    try:
        command = console_list[index]["command"]
        subprocess.run(command, shell=True)
    except Exception as e:
        messagebox.showerror("Erreur", f"Impossible de lancer la console : {e}")

# Fonction pour ajouter une nouvelle console
def add_console(console_list, listbox):
    name = name_entry.get()
    command = command_entry.get()
    description = description_entry.get()
    if name and command:
        console_list.append({"name": name, "command": command, "description": description})
        listbox.insert(tk.END, name)
        name_entry.delete(0, tk.END)
        command_entry.delete(0, tk.END)
        description_entry.delete(0, tk.END)
    else:
        messagebox.showwarning("Avertissement", "Veuillez remplir le nom et la commande.")

# Fonction pour afficher les détails d'une console
def show_details(event, console_list, details_text):
    selected_index = event.widget.curselection()
    if selected_index:
        index = selected_index[0]
        details_text.set(f"Nom : {console_list[index]['name']}\n"
                         f"Commande : {console_list[index]['command']}\n"
                         f"Description : {console_list[index]['description']}")

# Interface graphique
root = tk.Tk()
root.title("Gestionnaire de Consoles")
root.geometry("800x400")

# Cadre principal
frame_main = tk.Frame(root)
frame_main.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)

# Cadre pour la liste des consoles Serveur
frame_server = tk.Frame(frame_main, padx=10, pady=10)
frame_server.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

tk.Label(frame_server, text="Consoles Serveur", font=("Arial", 12, "bold")).pack(anchor="w")

server_listbox = tk.Listbox(frame_server, height=15, width=30)
server_listbox.pack(fill=tk.BOTH, expand=True)

server_scrollbar = tk.Scrollbar(frame_server)
server_scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

server_listbox.config(yscrollcommand=server_scrollbar.set)
server_scrollbar.config(command=server_listbox.yview)

for console in server_consoles:
    server_listbox.insert(tk.END, console["name"])

server_details_text = tk.StringVar()
server_details_label = tk.Label(frame_server, textvariable=server_details_text, justify=tk.LEFT, anchor="w")
server_details_label.pack(fill=tk.BOTH, pady=5)

server_listbox.bind("<<ListboxSelect>>", lambda event: show_details(event, server_consoles, server_details_text))

server_launch_button = tk.Button(frame_server, text="Lancer Serveur", command=lambda: launch_console(server_listbox.curselection()[0] if server_listbox.curselection() else -1, server_consoles))
server_launch_button.pack(pady=5)

# Cadre pour la liste des consoles Client
frame_client = tk.Frame(frame_main, padx=10, pady=10)
frame_client.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

tk.Label(frame_client, text="Consoles Client", font=("Arial", 12, "bold")).pack(anchor="w")

client_listbox = tk.Listbox(frame_client, height=15, width=30)
client_listbox.pack(fill=tk.BOTH, expand=True)

client_scrollbar = tk.Scrollbar(frame_client)
client_scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

client_listbox.config(yscrollcommand=client_scrollbar.set)
client_scrollbar.config(command=client_listbox.yview)

for console in client_consoles:
    client_listbox.insert(tk.END, console["name"])

client_details_text = tk.StringVar()
client_details_label = tk.Label(frame_client, textvariable=client_details_text, justify=tk.LEFT, anchor="w")
client_details_label.pack(fill=tk.BOTH, pady=5)

client_listbox.bind("<<ListboxSelect>>", lambda event: show_details(event, client_consoles, client_details_text))

client_launch_button = tk.Button(frame_client, text="Lancer Client", command=lambda: launch_console(client_listbox.curselection()[0] if client_listbox.curselection() else -1, client_consoles))
client_launch_button.pack(pady=5)

# Cadre pour ajouter une console
frame_add = tk.Frame(root, padx=10, pady=10)
frame_add.pack(fill=tk.BOTH)

tk.Label(frame_add, text="Nom :").grid(row=0, column=0, sticky="w")
name_entry = tk.Entry(frame_add, width=30)
name_entry.grid(row=0, column=1, padx=5)

tk.Label(frame_add, text="Commande :").grid(row=1, column=0, sticky="w")
command_entry = tk.Entry(frame_add, width=30)
command_entry.grid(row=1, column=1, padx=5)

tk.Label(frame_add, text="Description :").grid(row=2, column=0, sticky="w")
description_entry = tk.Entry(frame_add, width=30)
description_entry.grid(row=2, column=1, padx=5)

tk.Button(frame_add, text="Ajouter au Serveur", command=lambda: add_console(server_consoles, server_listbox)).grid(row=3, column=0, pady=5, sticky="w")
tk.Button(frame_add, text="Ajouter au Client", command=lambda: add_console(client_consoles, client_listbox)).grid(row=3, column=1, pady=5, sticky="e")

# Lancement de l'interface
root.mainloop()
