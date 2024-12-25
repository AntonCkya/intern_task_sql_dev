from collections import defaultdict
from functools import reduce

arr = [0,1,2,0,5,10,13,4,3,3,13,1,22,2,8,10,0,8,5]

def even_numbers(arr):
    return list(filter(lambda x: x % 2 == 0, arr))

def nums_with_counts(arr):
    arr_dict = defaultdict(lambda: 0)
    for i in arr:
        arr_dict[i] += 1
    arr_result = []
    for i in arr:
        # такое решение чтобы сохранить исходный порядок
        if arr_dict[i] != 0:
            arr_result.append((i, arr_dict[i]))
            arr_dict[i] = 0
    return arr_result

def odd_positions(arr):
    # считаем, что нумерация в массиве начинается с 0
    return arr[1::2]

def mult_no_zeros(arr):
    arr_no_zeros_filter = filter(lambda x: x != 0, arr)
    mult = reduce(lambda x, y: x * y, arr_no_zeros_filter)
    return mult

def sorted_diffs(arr):
    # возвращает список отсортированных разниц уникальных чисел
    arr_set = set()
    arr_uniq = []
    for i in arr:
        if i not in arr_set:
            arr_uniq.append(i)
            arr_set.add(i)
    for i in range(len(arr_uniq) - 1):
        arr_uniq[i] -= arr_uniq[i+1]
    arr_uniq = arr_uniq[:-1]
    return sorted(arr_uniq)

def sorted_diffs_2(arr):
    # возвращает список разниц отсортированных уникальных чисел
    arr_uniq = sorted(list(set(arr)))
    for i in range(len(arr_uniq) - 1):
        arr_uniq[i] -= arr_uniq[i+1]
    arr_uniq = arr_uniq[:-1]
    return sorted(arr_uniq)

def reversed_arr(arr):
    return arr[::-1]

def avg_arr(arr):
    return sum(arr) / len(arr)

def slice(arr, begin, end):
    return arr[begin:end + 1]

def strange_array_sum(arr):
    arr_copy = arr.copy()
    while len(arr_copy) != 1:
        curr_len = len(arr_copy) // 2 + len(arr_copy) % 2
        for i in range(curr_len):
            if i != len(arr_copy) // 2:
                arr_copy[i] += arr_copy[-i-1]
        arr_copy = arr_copy[:curr_len]
    return arr_copy[0]

def main():
    print(f"arr = {arr}")
    answers = {
        1: even_numbers(arr),
        2: nums_with_counts(arr),
        3: odd_positions(arr),
        4: mult_no_zeros(arr),
        5: sorted_diffs(arr),
        6: reversed_arr(arr),
        7: avg_arr(arr),
        8: slice(arr, 6, 10),
        9: strange_array_sum(arr)
    }
    for i in range(1, 9 + 1):
        print(f"{i}: {answers[i]}")

if __name__ == "__main__":
    main()
