import matplotlib.pyplot as plt
import subprocess as sp

sleep_delta = 1  # waiter for the end of fortran program execution
compiled_bins = './out.a'

graph_step = 1




def GetAndPlot(fname, label="", style=""):
    # with open(input("file for plot 1\n > "), "r")as file:
    with open(fname, "r")as file:
        data = file.read().split("\n")
        print(len(data))
        # data = [float(i) for i in file.read().split("\n") if i != '']
        data = [float(val) for val in data[:-1]]
        plt.plot([i*graph_step for i in range(len(data))], data , style, label=label, alpha=0.7 )



# list of files to process and respective save files
spectrum = ["data/spectre_1.txt","data/spectre_2.txt","data/spectre_3.txt","data/spectre_4.txt","data/spectre_5.txt",]
output_weight1 = ["output/sp1_1","output/sp2_1","output/sp3_1","output/sp4_1","output/sp5_1",]
output_weight_squared = ["output/sp1_sq","output/sp2_sq","output/sp3_sq","output/sp4_sq","output/sp5_sq",]


# process all all spectrum with weights of type 1
# note that the fortran file has to be compiled. we do not ask for 
# compilation here as it would require yet another depedency to run the program
for index in range(len(spectrum)):
    sp.call([compiled_bins, "ones", spectrum[index], output_weight1[index] ])
    print("\n\n\n\n")

# same for squared weights
for index in range(len(spectrum)):
    sp.call([compiled_bins, "square", spectrum[index], output_weight_squared[index] ])
    print("\n\n\n\n")



# creates the matplotlib plots
for index in range(len(spectrum)):
    GetAndPlot(spectrum[index], label="experimental", style="bo")
    GetAndPlot(output_weight1[index], label="weight: 1", style="r--")
    GetAndPlot(output_weight_squared[index], label="weight: **2", style="r-")
    plt.title(spectrum[index])
    plt.legend()
    plt.show()









