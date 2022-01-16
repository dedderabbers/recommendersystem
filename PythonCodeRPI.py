#import csv library
import csv as csv

# reading the csv file and defining data
with open("/Users/dedderabbers/Downloads/movierecommendersql-master/userReviews.csv",encoding="utf8",errors='ignore') as data:
    read_data = csv.reader(data, delimiter=';')
    data = list(read_data) # make a list of data rows

# Filter user scores on your favorite movie by user input
scores = 0 # to collect total users' scores
count=0 # to collect number of occurences
authors=[] # to collect all the authers who viewed user's favorite movie
moviename= input("Enter your favorite movie: ") # get the movie name from the user

# iterating through the data row list and find relavent data points and make calculations
for row in data:
    if row[0] == moviename:
        scores+=float(row[1]) # incrase score count
        count+=1 # increase count
        authors.append(row[2]) # add the auther to the list

m = scores/count # calculate the value of 'm'
print('The average of the user score for the movie',moviename,'is',m) # print out the finding

outputs=[] # this list is to collect the recommendation movies base on the conditions given

# iterate through the data list again and collect relavent data points
for row in data:
    # '[row[0]] not in outputs' condition ensures that there are no duplicated entities inside the outputs list
    if row[2] in authors and float(row[1])>=m and [row[0]] not in outputs:
        # we append the movie name as a list, because it will make easy the data writting process at the end
        outputs.append([row[0]])

outputs.insert(0, ['Recommendations']) # adding header of the output data. this will be the header of the column in csv file

# open a new csv file and write found recommendations to it
with open('recommendations.csv', 'w', encoding='UTF8', newline='') as output_file:
    writer = csv.writer(output_file)

    writer.writerows(outputs)  # write multiple rows
