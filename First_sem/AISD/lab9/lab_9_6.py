import time
import numpy as np
import random

def read_data(file_path):
    items = []
    with open(file_path, 'r') as file:
        for line in file:
            parts = line.strip().split(',')
            width, height, value = int(parts[1]), int(parts[2]), int(parts[3])
            items.append((width, height, value))
    return items

def display_knapsack(knapsack):
    for row in knapsack:
        print(" ".join(f"{int(cell):2}" for cell in row))
    print()

def greedy_knapsack_2d(items, knapsack_width, knapsack_height):
    items = sorted(items, key=lambda x: (x[2] / (x[0] * x[1])), reverse=True)
    total_value = 0
    knapsack = np.zeros((knapsack_height, knapsack_width))

    for item in items:
        width, height, value = item
        placed = False
        for i in range(knapsack_height - height + 1):
            for j in range(knapsack_width - width + 1):
                if np.all(knapsack[i:i+height, j:j+width] == 0):
                    knapsack[i:i+height, j:j+width] = value
                    total_value += value
                    placed = True
                    break
            if placed:
                break

    display_knapsack(knapsack)  # Display the knapsack state

    return total_value, knapsack

def dp_knapsack_2d(items, knapsack_width, knapsack_height):
    dp = np.zeros((len(items) + 1, knapsack_width + 1, knapsack_height + 1))
    keep = [[[0 for _ in range(knapsack_height + 1)] for _ in range(knapsack_width + 1)] for _ in range(len(items) + 1)]

    for k in range(1, len(items) + 1):
        width, height, value = items[k-1]
        for w in range(knapsack_width + 1):
            for h in range(knapsack_height + 1):
                if width <= w and height <= h:
                    if dp[k-1][w][h] > dp[k-1][w-width][h-height] + value:
                        dp[k][w][h] = dp[k-1][w][h]
                        keep[k][w][h] = 0
                    else:
                        dp[k][w][h] = dp[k-1][w-width][h-height] + value
                        keep[k][w][h] = 1
                else:
                    dp[k][w][h] = dp[k-1][w][h]
                    keep[k][w][h] = 0

    knapsack = np.zeros((knapsack_height, knapsack_width))
    w, h = knapsack_width, knapsack_height
    for k in range(len(items), 0, -1):
        if keep[k][w][h] == 1:
            width, height, value = items[k-1]
            w -= width
            h -= height
            for i in range(knapsack_height - h - height, knapsack_height - h):
                for j in range(knapsack_width - w - width, knapsack_width - w):
                    knapsack[i][j] = value

    display_knapsack(knapsack)  # Display the knapsack state

    return dp[len(items)][knapsack_width][knapsack_height]

def genetic_algorithm_knapsack_2d(items, knapsack_width, knapsack_height, population_size=10, generations=50, mutation_rate=0.01):
    def create_individual():
        return [random.choice([0, 1]) for _ in range(len(items))]

    def compute_fitness(individual):
        total_value = 0
        knapsack = np.zeros((knapsack_height, knapsack_width))
        for i, item_included in enumerate(individual):
            if item_included:
                width, height, value = items[i]
                placed = False
                for r in range(knapsack_height - height + 1):
                    for c in range(knapsack_width - width + 1):
                        if np.all(knapsack[r:r+height, c:c+width] == 0):
                            knapsack[r:r+height, c:c+width] = value  # Use value for visualization
                            total_value += value
                            placed = True
                            break
                    if placed:
                        break
                if not placed:
                    return 0, knapsack  # If item can't be placed, this individual is invalid
        return total_value, knapsack

    def crossover(parent1, parent2):
        crossover_point = random.randint(0, len(parent1) - 1)
        return parent1[:crossover_point] + parent2[crossover_point:]

    def mutate(individual):
        for i in range(len(individual)):
            if random.random() < mutation_rate:
                individual[i] = 1 - individual[i]

    population = [create_individual() for _ in range(population_size)]
    best_solution = None
    best_fitness = 0
    best_knapsack = None

    for generation in range(generations):
        fitness = []
        knapsacks = []
        for individual in population:
            fit, knapsack = compute_fitness(individual)
            fitness.append(fit)
            knapsacks.append(knapsack)

        max_fitness = max(fitness)
        if max_fitness > best_fitness:
            best_fitness = max_fitness
            best_solution = population[fitness.index(max_fitness)]
            best_knapsack = knapsacks[fitness.index(max_fitness)]

        selected = random.choices(population, weights=fitness, k=population_size)

        next_population = []
        for i in range(0, population_size, 2):
            parent1 = selected[i]
            parent2 = selected[i+1] if i+1 < population_size else selected[0]
            child1 = crossover(parent1, parent2)
            child2 = crossover(parent1, parent2)
            next_population.extend([child1, child2])

        for individual in next_population:
            mutate(individual)

        population = next_population[:population_size]

    display_knapsack(best_knapsack)  # Display the knapsack state

    return best_fitness

if __name__ == '__main__':
    file_path = 'C:\\Users\\mateu\\Desktop\\PI\\packages100.txt'
    items = read_data(file_path)

    knapsack_width = 100
    knapsack_height = 100

    start_greedy = time.time()
    greedy_value, greedy_knapsack = greedy_knapsack_2d(items, knapsack_width, knapsack_height)
    end_greedy = time.time()
    finish_greedy = end_greedy - start_greedy

    start_dp = time.time()
    dp_value = dp_knapsack_2d(items, knapsack_width, knapsack_height)
    end_dp = time.time()
    finish_dp = end_dp - start_dp

    start_ga = time.time()
    ga_value = genetic_algorithm_knapsack_2d(items, knapsack_width, knapsack_height)
    end_ga = time.time()
    finish_ga = end_ga - start_ga

    print("Greedy Solution Total Value:", greedy_value)
    print("Greedy Solution Time:", finish_greedy)

    print("DynamicProgramming Solution Total Value:", dp_value)
    print("DynamicProgramming Time:", finish_dp)

    print("Genetic Algorithm Solution Total Value:", ga_value)
    print("Genetic Algorithm Time:", finish_ga)
