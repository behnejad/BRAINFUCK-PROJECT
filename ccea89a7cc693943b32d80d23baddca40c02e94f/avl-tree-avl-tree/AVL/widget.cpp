#include "widget.h"

Widget::Widget(QWidget *parent)
    : QWidget(parent)
{
    AVL a ;
    Node * r;

    a.root= a.insert(a.root,9);
    a.root = a.insert(a.root,5);
    a.root= a.insert(a.root,10);
    a.root= a.insert(a.root,0);
    a.root= a.insert(a.root,6);
    a.root= a.insert(a.root,11);
    a.root= a.insert(a.root,-1);
    a.root= a.insert(a.root,1);
    a.root= a.insert(a.root,2);


    a.preorder(a.root);

  //  a.root=a.deleteNode(a.root,-1);
/*
    a.root= a.insert(a.root,6);
    a.root= a.insert(a.root,-1);


    a.root= a.insert(a.root,11);
    a.root= a.insert(a.root,1);
    a.root= a.insert(a.root,2);*/



    //a.preorder(a.root);






}

Widget::~Widget()
{
    
}
