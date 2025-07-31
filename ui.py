import tkinter as tk #UI Import
from tkinter import messagebox

from data_models import Player # data import

class ScoreApp:
    def __init__(self, root): # setup
        self.root = root
        self.root.title("Victor's TableTracker")

        self.turn = 1
        self.players = []

        self.current_phase_index = 0  # 0 for attacker, 1 for defender
        self.max_turns = 5

        self.setup_start_screen()

    def setup_start_screen(self): # start screen
        self.clear_frame()

        tk.Label(self.root, text="Player 1 Name (ATTACKER)").pack()
        self.p1_entry = tk.Entry(self.root)
        self.p1_entry.pack()

        tk.Label(self.root, text="Player 2 Name (DEFENDER)").pack()
        self.p2_entry = tk.Entry(self.root)
        self.p2_entry.pack()

        tk.Button(self.root, text="Start Game", command=self.start_game).pack(pady=10)

    def start_game(self): # game start, self-explanatory
        p1 = self.p1_entry.get().strip()
        p2 = self.p2_entry.get().strip()

        if not p1 or not p2:
            messagebox.showerror("Input Error", "Enter names for both players.")
            return

        self.players = [Player(p1), Player(p2)]
        self.build_score_ui()

    def build_score_ui(self):
        self.clear_frame()

        current_player = self.players[self.current_phase_index]
        current_player.add_cp()  # Add 1 CP at start of their phase

        tk.Label(self.root, text=f"Turn {self.turn} — {current_player.name}'s Phase", font=("Arial", 16)).pack(pady=5)

        self.cp_label = tk.Label(self.root, text=f"Command Points: {current_player.cp}", font=("Arial", 12)) # display for command points
        self.cp_label.pack()

        tk.Button(self.root, text="Use Command Point", command=self.use_command_point).pack() # command point button

        tk.Label(self.root, text="Primary Points this Phase:").pack() # Primary scoring
        self.score_var = tk.IntVar()
        tk.Entry(self.root, textvariable=self.score_var, width=5).pack()

        tk.Label(self.root, text="Secondaries (3):").pack() # Secondaries
        current_player.sec_vars = [tk.IntVar(value=s) for s in current_player.secondaries]
        for var in current_player.sec_vars:
            tk.Entry(self.root, textvariable=var, width=5).pack()

        tk.Button(self.root, text="Next Phase", command=self.next_phase).pack(pady=10) # next phase button

        self.root.deiconify() # fix for disappearing input boxes
        self.root.lift()         
        self.root.focus_force()

    def use_command_point(self): # Using command points
        player = self.players[self.current_phase_index]
        if player.cp > 0:
            player.use_cp()
            self.cp_label.config(text=f"Command Points: {player.cp}")
        else:
            messagebox.showwarning("No CP", f"{player.name} has no command points left.")
    
    def next_phase(self):
        player = self.players[self.current_phase_index]

        score = self.score_var.get() # saves data
        if self.turn <= 5:
            player.primary_scores[self.turn - 1] = score
        player.secondaries = [var.get() for var in player.sec_vars]

        if self.current_phase_index == 0: # Switch phase
            self.current_phase_index = 1
        else:
            self.current_phase_index = 0
            self.turn += 1

        if self.turn > 5: # only 5 turns
            messagebox.showinfo("Game Over", "There are only 5 turns in Warhammer 40,000")
            self.show_scores()
        else:
            self.build_score_ui()

    def show_scores(self):
        result = ""
        for player in self.players:
            result += (
                f"{player.name}:\n"
                f"  Primary: {player.total_primary()}\n"
                f"  Secondaries: {player.total_secondary()}\n"
                f"  Total: {player.total_score()}\n\n"
            )
        messagebox.showinfo("Final Scores", result)

    def clear_frame(self):
        for widget in self.root.winfo_children():
            widget.destroy()