import json

f = open('data.json')

data = json.load(f)

def check_for_vulnerabilities():
    for x in data['imageScanFindings']['findings']:
        if x['severity'] == 'CRITICAL' or x['severity'] == 'HIGH' or x['severity'] == 'MEDIUM':            
            f.close()
            return True
    f.close()
    return False

if __name__== '__main__':
    check_for_vulnerabilities()

