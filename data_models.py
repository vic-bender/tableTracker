import math #functional import

class Player: # all of the player info
    def __init__(self, name):
        self.name = name
        
        self.primary_scores = [0] * 5
        self.secondaries = [0, 0, 0]

        self.command_points = 1

    def use_cp(self):
        if self.command_points > 0:
            self.command_points = self.command_points - 1
    
    def add_cp(self):
        self.command_points = self.command_points + 1

    def total_primary(self):
        return sum(self.primary_scores)

    def total_secondary(self):
        return sum(self.secondaries)

    def total_score(self):
        return self.total_primary() + self.total_secondary()