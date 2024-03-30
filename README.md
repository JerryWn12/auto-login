# Usage

1. Create virtual interface on router with macvlan.
2. Edit `interfaces` variable in `run.sh` to your interface.
3. Generate `numbers.txt` file: `python generate_numbers.py`

4. ```shell script
   mv host.txt.example host.txt
   mv account_prefix.txt.example account_prefix.txt
   mv password.txt.example password.txt
   ```
5. Configure 3 files above with example files.
6. `bash run.sh`

tips
> Lively view log file with `tail -f log.txt`, successfully scanned account will be stored in `success.txt`.
> 
> Use `nohup` to run command in backround, for large storage device, instead of with `screen` is recommended.
