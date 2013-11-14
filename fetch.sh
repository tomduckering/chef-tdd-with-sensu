berks install --path chef/external-cookbooks

for cookbook in $(ls -1 chef/cookbooks)
do
	echo $cookbook
	rm -Rf ./chef/external-cookbooks/$cookbook
done