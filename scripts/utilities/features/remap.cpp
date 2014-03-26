#include <unistd.h>
#include <iostream>
#include <fstream>
#include <string>
#include <map>
#include <vector>
#include <algorithm>

using namespace std;

typedef map<string, int> Map;

int main(int argc, char *argv[]) {
    extern char *optarg;
    extern int optind;
    int ca=0,seqCol=0,posCol=0;
    char *mapFile,*inFile;
    bool help=false;
    while ((ca = getopt (argc, argv, "m:i:s:p:h?")) != -1)
        switch (ca) {
            case 'm': // map file
                mapFile = optarg;
                break;
            case 'i': // input file
                inFile = optarg;
                break;
            case 's':
                seqCol = atoi(optarg);
                break;
            case 'p':
                posCol = atoi(optarg);
                break;
            case 'h':
            case '?':
                help = true;
                break;
        }
    if (help) {
        cerr << "Usage: " << argv[0] << " -m <map> -i <input> -s <seq idx> -p <pos idx>\n";
        return 1;
    }
    // read map file into memory
    // map file has 8 columns
    // Achr, Astart, Aend, Bchr, Bstart, Bend, ori, etc 
    // It should be sorted by Achr and Astart
    ifstream input;
    input.open(mapFile,ifstream::in);
    
    string aChrom,bChrom,etc;
    int aFrom,aTo,bFrom,bTo,flip;
    string prevChr = "#unlikely";

    Map chrOffset;
    size_t vecSize=128;
    vector< vector<int> > aStart, aEnd, bStart, bEnd, ori;
    vector< vector<string> > extras,bChr;
    aStart.reserve(vecSize);
    aEnd.reserve(vecSize);
    bStart.reserve(vecSize);
    bEnd.reserve(vecSize);
    ori.reserve(vecSize);
    bChr.reserve(vecSize);
    extras.reserve(vecSize);
    int offset = -1;
    while (input >> aChrom >> aFrom >> aTo >> bChrom >> bFrom >> bTo >> flip >> etc) {
        if (aChrom != prevChr) {
            offset++;
            chrOffset.insert(Map::value_type(aChrom, offset));
            prevChr = aChrom;
            if (offset == aStart.size()) {
                vecSize *=2;
                aStart.resize(vecSize);
                aEnd.resize(vecSize);
                bStart.resize(vecSize);
                bEnd.resize(vecSize);
                ori.resize(vecSize);
                bChr.resize(vecSize);
                extras.resize(vecSize);
            }
        }
        aStart[offset].push_back(aFrom);
        aEnd[offset].push_back(aTo);
        bChr[offset].push_back(bChrom);
        bStart[offset].push_back(bFrom);
        bEnd[offset].push_back(bTo);
        ori[offset].push_back(flip);
        extras[offset].push_back(etc);
    }
    input.close();
    cerr << "finished reading map.\n";

    input.open(inFile, ifstream::in);
    string chr,context;
    char strand;
    int pos,coverage;
    float ratio;
    Map::iterator it;
    vector<int>::iterator up;
    prevChr = "#unlikely";
    while (input >> chr >> pos >> strand >> context >> ratio >> coverage) {
        if (chr != prevChr) {
            it = chrOffset.find(chr);
            prevChr = chr;
        }
        if (it != chrOffset.end()) {
            offset = it->second;
            up = upper_bound(aStart[offset].begin(),aStart[offset].end(),pos);
            // if (up != aStart[offset].end()) {
                // up is first element greater than pos
                // walk backwards until an interval ends before pos
                // doesn't deal with long intervals that start earlier
                int i = distance(aStart[offset].begin(),up)-1;
                
                while (i>=0 && aEnd[offset][i] > pos) {
                    int newpos = (bEnd[offset][i] - bStart[offset][i])*(pos-aStart[offset][i])/(aEnd[offset][i]-aStart[offset][i]);
                    if (ori[offset][i] == 1)
                        newpos += bStart[offset][i];
                    else
                        newpos = bEnd[offset][i] - newpos;

                    cout << bChr[offset][i] << "\t" << newpos << "\t"
                        << strand << "\t" << context << "\t" << ratio << "\t" << coverage << "\t" << extras[offset][i] << endl;

                    i--;
                }
            // }
        }
    }
    input.close();
    cerr << "finished\n";
    return 0;
}
