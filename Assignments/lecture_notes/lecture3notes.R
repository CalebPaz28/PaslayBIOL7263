Alot of this is used within a text editor program. 

Wildcards:
  \w - single word character
\d - single number number
\t - single tab
\s - single space
\n - line break (\r)

Quantifiers: 
  \w+ one or more word characters
\w* zero or more word characters
\w{3} exactly 3 characters 
\w{3,} three or more characters 
\w{3,5} 3-5 characters 

vanilla, chocolate, strawberry,  rocky road, (mint) chocolate chip

Haemorhous cassinii
Haemorhous purpureus
Haemorhous mexicanus

Find: (\w)\w+ (\w+)
Replace: \1_\2 or \1.\2 

H_cassinii        H.cassinii
H_purpureus       H.purpureus
H_mexicanus       H.mexicanus


### Using the shell (terminal)

pwd - current working directory
ls - files in the current directory (Example: ls Desktop/)
cd (change directory) - cd Desktop/
  cd ~ (returns to home directory)
mkdir - Makes a new folder
cd .. - takes us back to the previous directory 
rm -r - delete or remove files
cp - copy a file
mv - move a file
head - first line of file 
tail - last line of file


grep '^>' file name > capsicum_headers.fna (We can use the shell to find various features quickly)

How to unzip a file in terminal 
unzip ```file name```



sed 's/regex/elements to keep/' file_input > file_output 

sed 's/\(\>\w*\..\).*.(\(...*\)).*/\1 \2/' capsicum_headers.fna > EXAMPLE 

sed 's/\(\>\w*\..\).*.(\(...*\)).*/\1 \2/' protein.faa > protein_header.fna

Use ```less``` command to show the contents of a file 

sed 's/>/ \n\>/g' file.txt | sed -n '/RHO/,/^ /p' > RHO.txt

sed 's/>/ \n\>/g' file.txt | sed -n '/RHO/,/^>/p' > RHO.txt
This command will search for text within the file. 
#####Question 1
```
Find: ,
Replace: 
  Find: \s{3,} 
Replace: , 
```
Candidate Choice    Absentee Mail   Early Voting    Election Day    Total Votes
TODD RUSS   7,021   8,194   135,216   150,431
CLARK JOLLEY    7,012   5,835   107,714   120,561

Candidate Choice, Absentee Mail, Early Voting, Election Day, Total Votes
TODD RUSS, 7021, 8194, 135216, 150431
CLARK JOLLEY, 7012, 5835, 107714, 120561



