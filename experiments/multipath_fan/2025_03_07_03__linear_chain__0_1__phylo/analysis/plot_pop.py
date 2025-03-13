import pygame
import sys

pygame.init()
surf = pygame.Surface((1000, 3600))

index_dict = {}
counts = []

for line in sys.stdin:
    line = line.strip()
    parts = line.split(',')
    if len(parts) != 5:
        continue
    node_1 = int(parts[0])
    node_2 = int(parts[1])
    steps = int(parts[2])
    gen = int(parts[3])
    rep_id = int(parts[4])
    key = (gen, rep_id)
    if key not in index_dict:
        index_dict[key] = 0
    index = index_dict[key]
    index_dict[key] += 1
    #surf.set_at((gen // 100, index), (node_2 * 50, node_2 * 50, node_2 * 50))
    surf.set_at((gen, index), (node_2 * 50, node_2 * 50, node_2 * 50))
    while len(counts) <= gen:
        counts.append({})
    if node_2 not in counts[gen]:
        counts[gen][node_2] = 0
    counts[gen][node_2] += 1
pygame.image.save(surf, 'out.png')

surf.fill((0,0,0))
for gen in range(len(counts)):
    prev_y = 0
    for node_2 in sorted(list(counts[gen].keys())):
        count = counts[gen][node_2]
        for i in range(count):
            surf.set_at((gen, prev_y), (node_2 * 50, node_2 * 50, node_2 * 50))
            prev_y += 1
        
pygame.image.save(surf, 'muller.png')
