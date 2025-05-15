#include <vector>
#include <string>
using namespace std;

const int MOD = 1e9 + 7;

class Solution {
public:
    int lengthAfterTransformations(const string& s, int t, const vector<int>& nums) {
        vector<vector<int>> T = getTransformationMatrix(nums);
        vector<vector<int>> poweredT = matrixPow(T, t);
        vector<int> count(26, 0);
        vector<int> lengths(26, 0);

        for (char c : s) {
            count[c - 'a']++;
        }

        for (int i = 0; i < 26; i++) {
            for (int j = 0; j < 26; j++) {
                lengths[j] = (lengths[j] + 1LL * count[i] * poweredT[i][j] % MOD) % MOD;
            }
        }

        int total = 0;
        for (int len : lengths) {
            total = (total + len) % MOD;
        }

        return total;
    }

private:
    vector<vector<int>> getTransformationMatrix(const vector<int>& nums) {
        vector<vector<int>> T(26, vector<int>(26, 0));
        for (int i = 0; i < nums.size(); i++) {
            for (int step = 1; step <= nums[i]; step++) {
                T[i][(i + step) % 26]++;
            }
        }
        return T;
    }

    vector<vector<int>> getIdentityMatrix(int size) {
        vector<vector<int>> I(size, vector<int>(size, 0));
        for (int i = 0; i < size; i++) {
            I[i][i] = 1;
        }
        return I;
    }

    vector<vector<int>> matrixMult(const vector<vector<int>>& A, const vector<vector<int>>& B) {
        int size = A.size();
        vector<vector<int>> C(size, vector<int>(size, 0));
        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size; j++) {
                long long sum = 0;
                for (int k = 0; k < size; k++) {
                    sum = (sum + 1LL * A[i][k] * B[k][j]) % MOD;
                }
                C[i][j] = sum;
            }
        }
        return C;
    }

    vector<vector<int>> matrixPow(const vector<vector<int>>& M, int n) {
        if (n == 0) return getIdentityMatrix(M.size());
        if (n % 2 == 1) return matrixMult(M, matrixPow(M, n - 1));
        vector<vector<int>> half = matrixPow(M, n / 2);
        return matrixMult(half, half);
    }
};
