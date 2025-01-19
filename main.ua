# Experimental!

$ To play, move with 'wasd'.
$ Excavate a tile with 'x'.
$ Toggle a flag with 'f'.
$ Quit with 'q'.
$ You win when all the bombs are flagged.
$ 
$ Press enter to continue from this message.
$ 
$ The bombs indicating the numbers don't loop over to the other side.
$ But if you want to add that, you can comment the current code for showing number out, and put that back in.
$ 
$ Have fun!
&p
◌ &sc

# Bombs
BombCount ← 1
# Shape
S ← 10_10

# Number of Cells
/×S
C ←
°△S
°⍆⇡C
⊏⇡BombCount
∊

.
BombGrid ←

# Loops the numbers to the other side
# Adj ← ♭₂-1⇡3_3
# /+≡↻Adj¤

# Doesn't loop the number to the other side
⬚0⧈(/+/+) 3_3
↘₁
↘₋₁
≡↘₁
≡↘₋₁

.
Board ←

⊜□:⇡△.¬
ZeroChunks ←

# Exit with an error message.
PExit ← (
  &p
  &exit 0
)

LocationsToShow ← (
  # Take in the location and outputs
  # a list of locations to show
  # If the selected digit is 0, then show all digits
  # In that chunk. Otherwise, just show that location.
  :ZeroChunks

  &p.
  ⍣(¤

    ⊸≡(/↥/↥⌕⊙°□)
    ⊚

    ⊡₀
    ⊡
    °□
  | ¤)
)

Show ← (
  LocationsToShow
  ⍜⊡(
    ≡(0⋅)
  )
)

# Take in a point to excavate (cursor) and the viewable map
# and return back that point along with a new viewable map
Excavate ← (
  ⊃(∘
  | (
      ⊡₀/↥⌕:⊚BombGrid
      # If 1, then the player hit a bomb location. This means they died.
      ◌⨬(∘|PExit "You died!")
    )
  | (
      Show
    )
  )
)

# Take in a point to flag (cursor), the viewable matrix (we can skip over this) and the flag map (we append to this)
# Returns back the cursor, the viewable matrix, and the new flag list.
ToggleFlag ← (
  ⍜:(
    ⊙(
      ⟜(
        ⍜⊡¬
        ⊸≍BombGrid
        ⨬(∘|PExit "You won!")
      )
    )
  )
)

# Takes in the cursor, hidden tiles, flags
# it returns new versions of these.
Loop ← (
  # On the top of the stack is the cursor. Below that is the viewability grid.
  &p "\x1bc"
  ◡(
    ⊙(
      :°⋕Board
      ≡⍜▽(@_◌)
      :
      ≡⍜▽(@F◌)
    )
    ⍜⊡⍚$"\x1b[41m_\x1b[0m"
    ⍚(/$"_ _")
    /$"_\n_"
    &p
  )

  ⊗⊙"wasdxfq" ⊢⍜(&raw|&rs 1 0)1

  ⨬(◿ S+¯1_0 # W
  | ◿ S+0_¯1 # A
  | ◿ S+1_0  # S
  | ◿ S+0_1  # D
  | Excavate
  | ToggleFlag
  | PExit "Quitting"
  | ∘
  )
)
# Initally there are no flags
↯S0
# Initially everything is hidden
↯S1
0_0
◌⍢Loop1
