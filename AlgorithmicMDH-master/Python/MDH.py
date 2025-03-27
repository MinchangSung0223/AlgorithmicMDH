
class MDH:
    def __init__(self,alpha,a,d,theta):
        self.alpha = alpha;
        self.a = a;
        self.d = d;
    def __str__(self):
        table = "| alpha      | a          | d          | theta      |\n"
        table += "|------------|------------|------------|------------|\n"
        
        for i in range(len(self.alpha)):
            table += f"| {self.alpha[i]:<10.4f} | {self.a[i]:<10.4f} | {self.d[i]:<10.4f} | {self.theta[i]:<10.4f} |\n"
        
        return table