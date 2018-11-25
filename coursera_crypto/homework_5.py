from gmpy2 import mpz, invert, powmod, divm, f_mod

def compute_discrete_log(p, h, g, B):
    map = {}
    g_to_the_B = powmod(g, B, p)
    for x0 in range(1, 2 ** 20):
        map[powmod(g_to_the_B, x0, p)] = x0

    print("Done with step 1!")

    for x1 in range(1, 2 ** 20):
        g_to_x1 = powmod(g, x1, p)
        left_hand = f_mod(invert(g_to_x1, p) * h, p)
        if map.get(left_hand) is not None:
            x0 = map.get(left_hand)
            print((x0, x1, B))
            return mpz(x0) * B + mpz(x1)

    return "No luck"

B = mpz(2 ** 20)
p = mpz(13407807929942597099574024998205846127479365820592393377723561443721764030073546976801874298166903427690031858186486050853753882811946569946433649006084171)
g = mpz(11717829880366207009516117596335367088558084999998952205599979459063929499736583746670572176471460312928594829675428279466566527115212748467589894601965568)
h = mpz(3239475104050450443565264378728065788649097520952449527834792452971981976143292558073856937958553180532878928001494706097394108577585732452307673444020333)

discrete_log = compute_discrete_log(p, h, g, B)
print(discrete_log)
