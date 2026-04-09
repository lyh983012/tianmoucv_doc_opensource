cd ../tianmoucv
sh update.sh
cd ../tianmoucv_doc_opensource
make clean
make html
sudo systemctl restart nginx