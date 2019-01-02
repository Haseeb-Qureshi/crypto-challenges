from gmpy2 import mpz, mul, div, square, sqrt, add, sub, invert, powmod
import gmpy2

N = mpz(179769313486231590772930519078902473361797697894230657273430081157732675805505620686985379449212982959585501387537164015710139858647833778606925583497541085196591615128057575940752635007475935288710823649949940771895617054361149474865046711015101563940680527540071584560878577663743040086340742855278549092581)

def find_sqrt_ceil(N):
    lower_bound = mpz(2)
    upper_bound = N
    while True:
        times_two = mul(lower_bound, 2)
        if square(times_two) > N:
            upper_bound = times_two
            break
        else:
            lower_bound = times_two
    while True:
        middle = div(lower_bound + upper_bound, 2)
        if square(middle) == N:
            return middle
        elif square(middle) < N and square(middle + 1) > N:
            return middle + 1
        elif square(middle) < N:
            lower_bound = middle
        else:
            upper_bound = middle

A = find_sqrt_ceil(N)
x = find_sqrt_ceil(square(A) - N)
p = A - x
q = A + x

print("-" * 20)
print("Part 1:")
print("p: ", p, " q: ", q)
print("-" * 20)
print("Part 2:")

N2 = mpz(648455842808071669662824265346772278726343720706976263060439070378797308618081116462714015276061417569195587321840254520655424906719892428844841839353281972988531310511738648965962582821502504990264452100885281673303711142296421027840289307657458645233683357077834689715838646088239640236866252211790085787877)

root_n = find_sqrt_ceil(N2)
A2 = root_n + 1
x2 = None
while A2 < root_n + 2 ** 20:
    x2 = find_sqrt_ceil(square(A2) - N2)
    if mul(A2 - x2, A2 + x2) == N2:
        break
    A2 += 1

print("p: ", A2 - x2, " q: ", A2 + x2)
print("-" * 20)
print("Part 3:")

N3 = mpz(720062263747350425279564435525583738338084451473999841826653057981916355690188337790423408664187663938485175264994017897083524079135686877441155132015188279331812309091996246361896836573643119174094961348524639707885238799396839230364676670221627018353299443241192173812729276147530748597302192751375739387929)

def break_challenge_3(N3):
    A = gmpy2.isqrt(6 * N3)
    AA = 2 * A + 1

    (res, rem) = gmpy2.isqrt_rem(AA ** 2 - 24 * N3)

    (p, rem1) = gmpy2.c_divmod(res + AA, 4)
    (q, rem2) = gmpy2.c_divmod(res - AA, 6)

    if rem != 0 or rem2 != 0:
    	(p, rem1) = gmpy2.c_divmod(res - AA, 4)
    	(q, rem2) = gmpy2.c_divmod(res + AA, 6)

    assert(abs(p * q) == N3)
    return min(abs(p), abs(q))


print(break_challenge_3(N3))

print("-" * 20)
print("Part 4:")

CHALLENGE_CIPHERTEXT = mpz(22096451867410381776306561134883418017410069787892831071731839143676135600120538004282329650473509424343946219751512256465839967942889460764542040581564748988013734864120452325229320176487916666402997509188729971690526083222067771600019329260870009579993724077458967773697817571267229951148662959627934791540)
e = 65537

phi_N = mul(p - 1, q - 1)
# m^(e * d) = m
# e * d = 1
# d = modinv(e, phi_N)
d = invert(e, phi_N)
plaintext = powmod(CHALLENGE_CIPHERTEXT, d, N)
assert(mul(p, q) == N)
assert(powmod(powmod(CHALLENGE_CIPHERTEXT, d, N), e, N) == CHALLENGE_CIPHERTEXT)
print(bytearray.fromhex(hex(plaintext).split('00')[1]).decode())
