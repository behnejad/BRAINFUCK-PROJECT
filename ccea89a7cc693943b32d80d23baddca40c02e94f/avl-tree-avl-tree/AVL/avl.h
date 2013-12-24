#ifndef AVL_H
#define AVL_H
#include "Node.h"
#include <QtCore>
#include <QDebug>
class AVL
{
public:
    int height(Node * );
    AVL();
    Node * RR(Node * );
    Node * LL ( Node * );
    int getBalance(Node * );
    Node * insert(Node * ,int);
    Node * deleteNode(Node * , int );
    Node * minValueNode(Node * );
    void preorder(Node *);
    Node * root ;
};

#endif // AVL_H
