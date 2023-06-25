# Environmental Impact of various cuts of meat (Interactive Dashboard in R)

All the pictures used are in /www folder.

Data and pictures for cuts and cow parts come from: https://www.certifiedherefordbeef.com/recipes/cuts/

Data of Protein and Calories of each cut come from: https://www.myfitnesspal.com/


Plotting datasets:
Scatter plot for showing overall environmental impact: The plot was made with the type of cut on the x axis, and the carbon emission on the Y axis. The size of the data points are determined by the number of cows used per selection. The color of the data points depend on the Land usage of the cut selection. Blue color indicates a lower land usage and the red color indicates a higher land usage.

Subplots:
subplots show the breakdown of the individual environmental impact of each variable (number of cows used, co2 emission, land usage and the water usage) vs the selection of cut.


Summary table:
Summary table is populated based on the amount of meat and the selection of cut input from the user. The column that indicate the number of cows used is populated based on the amount of meat that was entered divided by the total weight of the selected meat that can be obtained from 1 cow. Constant values per cow were calculated for the co2 emission, land usage and the water usage. The associated columns were populated by multiplying the number of cows with the respective constants.
