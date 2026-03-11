import csv
import time
cor=[]
def n_pattern_search(s_array, pattern):
    result=[]
    for array_row in range(len(s_array)-len(pattern)+1):
        for array_column in range(len(s_array[array_row])-len(pattern[0])+1):
            if s_array[array_row][array_column]==pattern[0][0]:
                is_pattern=True
                for pattern_row in range(len(pattern)):
                    for pattern_column in range(len(pattern[pattern_row])):
                        if s_array[array_row+pattern_row][array_column+pattern_column]!=pattern[pattern_row]\
                            [pattern_column] and pattern[pattern_row][pattern_column]!='?':
                            is_pattern=False
                            break
                if is_pattern:
                    result.append((array_row,array_column))
    return result
d=17
q=101
def rabin_karp_p(str_array, pattern):
    global cor
    results = []
    p_w = len(pattern[0])
    p_h = len(pattern)
    s_w = len(str_array[0])
    s_h = len(str_array)
    pattern_horizontal_hash = 0
    pattern_vertical_hash = 0
    for i in range(p_w):
        pattern_horizontal_hash = (d * pattern_horizontal_hash + ord(pattern[0][i])) % q
    for i in range(p_h):
        pattern_vertical_hash = (d * pattern_vertical_hash + ord(pattern[i][0])) % q

    h = 1
    for i in range(p_w - 1):
        h = (d * h) % q
    rows_hashed = []
    row_index = 0
    hash_start = time.time()
    for row in str_array:

        first_window_hash = 0
        for i in range(p_w):
            first_window_hash = (d * first_window_hash + ord(row[i])) % q
        rows_hashed.append([first_window_hash])
        window_hash = first_window_hash

        for i in range(len(row) - p_w):
            window_hash = (d * (window_hash - ord(row[i]) * h) + ord(row[i + p_w])) % q
            if window_hash < 0:
                window_hash = window_hash + q
            rows_hashed[row_index].append(window_hash)
        row_index += 1

    cols_hashed = []
    for col_index in range(s_w):
        first_column_hash = 0
        for row_index in range(p_h):
            first_column_hash = (d * first_column_hash + ord(str_array[row_index][col_index])) % q
        cols_hashed.append([first_column_hash])
        window_hash = first_column_hash
        for row_index in range(len(str_array) - p_h):
            window_hash = (d * (window_hash - ord(str_array[row_index][col_index]) * h) + ord(
                str_array[row_index + p_h][col_index])) % q
            cols_hashed[col_index].append(window_hash)
    hash_end = time.time()
    for i in range(s_w - p_w):
        for j in range(s_h - p_h):
            if pattern_horizontal_hash == rows_hashed[i][j] and pattern_vertical_hash == cols_hashed[j][i]:
                is_correct = True
                for k in range(3):
                    for m in range(3):
                        if str_array[i + k][j + m] != pattern[k][m] and pattern[k][m] != '?':
                            is_correct = False
                if is_correct:
                    results.append((i, j))
    print(results)#do mierzenia czasu wykonania usunąć bo zaburzy pomiar
    print(len(results))
    results.append(hash_end - hash_start)
    return results



        
def main():
    sample_data=[]
    pattern=['ABC','B??','C??']
    f=open('result2.csv','w')
    header=['N','naive','rabin_t','coordinates']
    writer=csv.writer(f,dialect='excel')
    writer.writerow(header)

    sample_data = [char for char in open('C:\\Users\\mateu\\Desktop\\patterns\\1000_pattern.txt', 'r').read().splitlines()]
    naive_start = time.time()
    n_pattern_search(sample_data, pattern)
    naive_end = time.time()
    hash_time = rabin_karp_p(sample_data, pattern)[-1]
    rabin_end = time.time()
    writer.writerow([1000, naive_end - naive_start, rabin_end - naive_end])
    
    
    print('1')
    sample_data = [char for char in open('C:\\Users\\mateu\\Desktop\\patterns\\2000_pattern.txt', 'r').read().splitlines()]
    
    naive_start = time.time()
    n_pattern_search(sample_data, pattern)
    naive_end = time.time()
    hash_time = rabin_karp_p(sample_data, pattern)[-1]
    rabin_end = time.time()
    writer.writerow([2000, naive_end - naive_start, rabin_end - naive_end])
    
    print('2')
    sample_data = [char for char in open('C:\\Users\\mateu\\Desktop\\patterns\\3000_pattern.txt', 'r').read().splitlines()]
    
    naive_start = time.time()
    n_pattern_search(sample_data, pattern)
    naive_end = time.time()
    hash_time = rabin_karp_p(sample_data, pattern)[-1]
    rabin_end = time.time()
    writer.writerow([3000, naive_end - naive_start, rabin_end - naive_end])
    print()
    
    print('3')
    sample_data = [char for char in open('C:\\Users\\mateu\\Desktop\\patterns\\4000_pattern.txt', 'r').read().splitlines()]
    
    naive_start = time.time()
    n_pattern_search(sample_data, pattern)
    naive_end = time.time()
    hash_time = rabin_karp_p(sample_data, pattern)[-1]
    rabin_end = time.time()
    writer.writerow([4000, naive_end - naive_start, rabin_end - naive_end])
    
    print('4')
    sample_data = [char for char in open('C:\\Users\\mateu\\Desktop\\patterns\\5000_pattern.txt', 'r').read().splitlines()]
    
    naive_start = time.time()
    n_pattern_search(sample_data, pattern)
    naive_end = time.time()
    hash_time = rabin_karp_p(sample_data, pattern)[-1]
    rabin_end = time.time()
    writer.writerow([5000, naive_end - naive_start, rabin_end - naive_end])
    print('5')


if __name__=='__main__':
    main()
