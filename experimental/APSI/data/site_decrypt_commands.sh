./bin/site_decrypt -c data/context.bin -p data/publickey.bin -e data/evalkeys.bin -r data/privatekey_0.bin < data/aggregated_0.ctext > data/partial_dec_0_0.par
echo -e '\tFinished partial decryption for key share 0, partition 0'
./bin/site_decrypt -c data/context.bin -p data/publickey.bin -e data/evalkeys.bin -r data/privatekey_0.bin < data/aggregated_0.ctext > data/partial_dec_0_1.par
echo -e '\tFinished partial decryption for key share 1, partition 0'
