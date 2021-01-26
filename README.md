# InstaFollow

A small Ruby script to help you backup your following accounts from one Instagram account from another.

## Use Case: 

Are you worried that Instagram might "randomly"[1] delete your account? 

You can always make a new backup account, but how will you follow all your favorite accounts again? 

Manually? No, save your fingerwork for something better. 

Just let a computer follow those accounts for you!

[1] This is not pure randomness as experts might argue.

## How to Use: 

1. Set up an your login information as enviornment variables in your `~/.zshrc` or `~/.bashrc` file, like this:

```
export INSTAFOLLOWUSER='(Your username)'
     
export INSTAFOLLOWPW='(Your password)'
```

2. `cd` to this directory

3. Make a list of accounts you want to follow in `list` file (located in repository). For each account you want to follow, write it in a new line.

Example: 
```
github
bigdataguru
thecodergeek
programmerplus
coolandsmartrr
```

4. Run this line in terminal:
```
ruby main.rb
```

## Any questions?

Set up a new "Issue" on this Github repository.
