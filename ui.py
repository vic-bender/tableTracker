import tkinter as tk
from tkinter import messagebox

from data_models import Player

class ScoreApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Victor's TableTracker")

        self.turn = 1
        self.players = []

        self.setup_start_screen()

    def setup_start_screen(self):
        self.clear_frame()

        tk.Label(self.root, text="Player 1 Name").pack()
        self.p1_entry = tk.Entry(self.root)
        self.p1_entry.pack()

        tk.Label(self.root, text="Player 2 Name").pack()
        self.p2_entry = tk.Entry(self.root)
        self.p2_entry.pack()

        tk.Button(self.root, text="Start Game", command=self.start_game).pack(pady=10)

    def start_game(self):
        p1 = self.p1_entry.get().strip()
        p2 = self.p2_entry.get().strip()

        if not p1 or not p2:
            messagebox.showerror("Input Error", "Enter names for both players.")
            return

        self.players = [Player(p1), Player(p2)]
        self.build_score_ui()

    def build_score_ui(self):
        self.clear_frame()
        self.score_vars = []

        tk.Label(self.root, text=f"Turn {self.turn}", font=("Arial", 16)).pack(pady=5)

        for i, player in enumerate(self.players):
            tk.Label(self.root, text=f"{player.name}", font=("Arial", 14)).pack()

            turn_frame = tk.Frame(self.root)
            turn_frame.pack()
            tk.Label(turn_frame, text="Primary Points this Turn:").pack(side=tk.LEFT)
            var = tk.IntVar()
            self.score_vars.append(var)
            tk.Entry(turn_frame, textvariable=var, width=5).pack(side=tk.LEFT)

            sec_frame = tk.Frame(self.root)
            sec_frame.pack()
            tk.Label(sec_frame, text="Secondaries (3):").pack(side=tk.LEFT)
            player.sec_vars = [tk.IntVar(value=s) for s in player.secondaries]
            for var in player.sec_vars:
                tk.Entry(sec_frame, textvariable=var, width=5).pack(side=tk.LEFT)

        tk.Button(self.root, text="Next Turn", command=self.next_turn).pack(pady=10)
        tk.Button(self.root, text="Show Final Score", command=self.show_scores).pack()

        self.root.deiconify()    # Make sure window isn't minimized
        self.root.lift()         # Bring window to front
        self.root.focus_force()  # Focus window

    def next_turn(self):
        for i, player in enumerate(self.players):
            score = self.score_vars[i].get()
            if self.turn <= 5:
                player.primary_scores[self.turn - 1] = score
            player.secondaries = [var.get() for var in player.sec_vars]

        if self.turn < 5:
            self.turn += 1
            self.build_score_ui()
        else:
            messagebox.showinfo("Game Over", "Reached turn 5.")
            self.show_scores()

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