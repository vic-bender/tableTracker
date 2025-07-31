import tkinter as tk
from tkinter import messagebox

from ui import ScoreApp #UI import

if __name__ == "__main__":
    root = tk.Tk()
    app = ScoreApp(root)
    root.mainloop()