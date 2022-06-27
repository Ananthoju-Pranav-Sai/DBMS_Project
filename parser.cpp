#include <iostream>
#include <fstream>
#include <string>
#include <string.h>
#include <map>
#include <algorithm> 

using namespace std;
 

const string WHITESPACE = " \n\r\t\f\v";
 
string ltrim(const std::string &s)
{
    size_t start = s.find_first_not_of(WHITESPACE);
    return (start == string::npos) ? "" : s.substr(start);
}

int main()
{
    string s;
    ifstream Myfile("source.txt");
    ofstream paper;
    ofstream author;
    ofstream venue;
    ofstream written_by;
    ofstream citations;

    string delim = "\u0007";

    paper.open("paper.csv");
    author.open("author.csv");
    venue.open("venue.csv");
    written_by.open("written_by.csv");
    citations.open("citations.csv");

    paper << "paper_id"<<delim<<"title"<<delim<<"abstract"<<delim<<"year\n";
    author << "auth_id"<<delim<<"first"<<delim<<"last\n";
    venue << "v_name"<<delim<<"paper_id\n";
    written_by << "auth_id"<<delim<<"paper_id"<<delim<<"rank\n";
    citations << "paper_id_1"<<delim<<"citationspaper_id_2\n";

    getline(Myfile, s);

    string p_row;
    int paper_id;
    string title;
    string abstract;
    string year;
    int cited;

    string v_row;
    string v_name;
    string temp;
    
    string a_row;
    string writers;
    string writer = "";

    map<string, int> mp;
    int a_id = 1;
    int rank = 1;
    int i = 0;
    int p_id = 0;

    while (getline(Myfile, s))
    {
        if (s.substr(0, 2) == "#*")
        {
            s = s.substr(2, s.length() - 2);
            for(auto c:s)
            {
                if(c=='\''||c=='\"')
                {
                    title+=c;    
                }
                title+=c;
            }
        }
        else if (s.substr(0, 2) == "#t")
            year = s.substr(2, s.length() - 2);
        else if (s.length()>6 && s.substr(0, 6) == "#index")
        {
            paper_id = stoi(s.substr(6, s.length() - 6));
        }
        else if (s.substr(0, 2) == "#!")
        {
            s = s.substr(2, s.length() - 2);
            for(auto c:s)
            {
                if(c=='\''||c=='\"')
                {
                    abstract+=c;    
                }
                abstract+=c;
            }
        }
        else if (s.substr(0, 2) == "#c")
        {
            temp = s.substr(2, s.length() - 2);
            for(auto c:temp)
            {
                if(c=='\''||c=='\"')
                {
                    v_name+=c;    
                }
                v_name+=c;
            }
            temp="";
        }
        else if (s.substr(0, 2) == "#%")
        {
            cited = stoi(s.substr(2, s.length()-2));
            if(p_id != cited)
                citations << p_id << delim << cited << "\n";
        }

        else if (s.substr(0, 2) == "#@")
        {
            rank=1;
            writers = s.substr(2, s.length() - 2);
            writer="";
            map<string,int>considered;
            for (auto x : writers)
            {
                if (x == ',')
                {
                    if(mp[writer]==0)
                    {
                        mp[writer] = a_id;
                        a_id++;
                    }
                    if(!considered[writer])
                    {
                        considered[writer]=1;
                        written_by << mp[writer] << delim;
                        written_by << p_id;
                        written_by << delim << rank << "\n";
                        rank++;
                    }
                        writer="";
                }
                else
                {
                    writer = writer + x;
                }
            }
            if(mp[writer]==0)
            {
                mp[writer] = a_id;
                a_id++;
            }
            if(!considered[writer])
            {
                written_by << mp[writer] << delim;
                written_by << p_id;
                written_by << delim << rank << "\n";
                rank++;
            }
        }

        p_row = delim + title + delim + abstract + delim;
        v_row = v_name + delim;

        if (s == "\0")
        {
            p_id++;
            paper << paper_id;
            paper << p_row;
            paper << stoi(year) << "\n";

            venue << v_row;
            venue << paper_id;
            venue << "\n";

            p_row="";
            title="";
            abstract="";
            year="";
            v_row="";
            v_name="";
            i++;
        }
    }
    string name = "";
    string first;
    string last;
    int f=0;

    for (auto itr = mp.begin(); itr != mp.end(); itr++)
    {
        name = itr->first;
        name = ltrim(name);
        author << itr->second << delim; 
        for (auto x : name)
        {
            if(x==' ' && first!="")
                f=1;
            if(f)
            {
                if(x=='\''||x=='\"')
                {
                    last+=x;
                    
                }
                last+=x;
            }
            else
            {
                if(x=='\''||x=='\"')
                {   
                    first+=x;
                }
                first+=x;
            }
        }
        f=0;
        author << first << delim << last << '\n';
        first="";
        last="";
        name="";
    }
}