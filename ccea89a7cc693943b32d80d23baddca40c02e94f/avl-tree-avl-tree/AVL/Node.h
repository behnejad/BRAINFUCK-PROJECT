#ifndef NODE_H
#define NODE_H
#include <QtCore>
class Node
{
    // An AVL tree node class
public:
    int key ;
    Node * right;
    Node * left;
    int height ;
    Node();
    Node(int);
};

#endif // NODE_H
