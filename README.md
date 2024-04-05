# Usage

1. Create virtual interface on router with macvlan.
2. Edit `interfaces` variable in `run.sh` to your interface.
3. Generate `numbers.txt` file: `python generate_numbers.py`.

4. ```shell script
   mv host.txt.example host.txt
   mv account_prefix.txt.example account_prefix.txt
   mv password.txt.example password.txt
   ```
5. Configure 3 files above with example files.
6. `chmod 744 run.sh`
7. `./run.sh`

tips
> Lively view log file with `tail -f run.log`, successfully scanned account will be stored in `success.txt`.
> 
> Use `nohup ./run.sh &` to run it in background, for large storage device, instead of with `screen` is recommended.
