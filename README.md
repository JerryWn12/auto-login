# Usage

1. Create 3 virtual lan interface(vth0, vth1, vth2) on router with macvlan.
2. Generate `numbers.txt` file: `python generate_numbers.py`

3. ```shell script
   mv host.txt.example host.txt
   mv account_prefix.txt.example account_prefix.txt
   mv password.txt.example password.txt
   ```
4. Configure 3 files above with example files.
5. `bash login.sh`

tips
> Lively view log file with `tail -f log.txt`, successfully scanned account will be stored in `success.txt`.
> 
> Use `nohup` to run command in backround, for large storage device, instead of with `screen` is recommended.
