import sys


file_path = sys.argv[1]
rep_id = int(sys.argv[2])
rep_seed = int(sys.argv[3])

print('rep_id,rep_seed,trial_id,trial_seed,update,node_id,node_name,discovery_site_idx')
with open(file_path, 'r') as in_fp:
    for line in in_fp:
        if 'START TRIAL' in line:
            line_parts = line.split()
            trial_id = int(line_parts[2])
            trial_seed = int(line_parts[5])
            #print(trial_id, trial_seed)
        elif 'UD:' in line:
            line_parts = line.split()
            update = int(line_parts[0].split(':')[1])
        elif 'discovered' in line:
            #print('Update:', update)
            #print(line.strip())
            line_parts = line.split()
            node_id = int(line_parts[1])
            node_name = line_parts[2].strip(')').strip('(')
            discovery_site_idx = int(line_parts[6])
            print(str(rep_id) + ',' + str(rep_seed) + ',' \
                    + str(trial_id) + ',' + str(trial_seed) + ',' + str(update) + ',' \
                    + str(node_id) + ',' + node_name + ',' + str(discovery_site_idx))
