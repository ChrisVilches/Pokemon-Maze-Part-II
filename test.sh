echo Testing...

for f in test/in*.txt
do
	echo Test ${f//[^0-9]/}
	diff <(ruby main.rb < $f) <(cat ${f/in/sol})
done

echo "Ok"
