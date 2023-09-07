# ========================================================================
# ZSH conf specific to Yobi (work) environment
# ========================================================================

# ------------------------------------------------------------------------
# Functions 
# ------------------------------------------------------------------------

# Generate a new customer ID to use with Pixel
function gen-pixel-cid {
    python3 -c "import random, string; print('yb' + ''.join(random.choice(string.ascii_lowercase + string.digits) for _ in range(8)))"
}

# Generate a new advertiser ID to use with Pixel
function gen-pixel-aid {
    python3 -c "import random, string; print(''.join(random.choice(string.ascii_lowercase + string.digits) for _ in range(8)))"
}
