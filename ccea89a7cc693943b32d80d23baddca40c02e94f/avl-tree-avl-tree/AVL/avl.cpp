#include "avl.h"

Node::Node(){


}

Node::Node(int key ){
    this->key=key;
    this->height= 1;
    this->left= NULL;
    this->right= NULL;

}

AVL::AVL()
{
    root = new Node;
    root= NULL;
}

int AVL::height(Node * n ){
    if (n==NULL){
        return 0 ;
    }
    return n->height;
}


Node * AVL::RR(Node * y){
    Node * x = new Node;
    x= y->left;
    Node * t2 = x->right;
    t2= x->right;

    x->right= y ;
    y->left= t2;

    // Update heights
    y->height = qMax(height(y->left), height(y->right))+1;
    x->height = qMax(height(x->left), height(x->right))+1;

    return x ;
}
Node * AVL::LL(Node * x){

    Node * y = new Node ;
    y=x->right;
    Node * t2 = new Node ;
    x->right= t2;

    y->left=x;
    x->right=t2;

    x->height = qMax(height(x->left), height(x->right))+1;
    y->height = qMax(height(y->left), height(y->right))+1;

    return y ;
}


int AVL::getBalance(Node * n ){
    if (n== NULL){
            return 0 ;
    }
    return this->height(n->left)- this->height(n->right);
}
Node * AVL::insert(Node * node, int key){
    if (node ==NULL){
        Node * t = new Node(key);
        return t;

    }
    if (key < node->key){
        node->left = insert(node->left,key);
    }else
    {
        node->right= insert(node->right,key);
    }

    node->height = qMax(this->height(node->left), this->height(node->right)) + 1;

    int balance = getBalance(node);

    if (balance>1 && key<node->left->key){
        return RR(node);
    }

    if (balance<-1 && key> node->right->key){
        return RR(node);
    }

    if (balance>1 && key>node->left->key){
        node->left=LL(node->left);
        return RR(node);
    }

    if (balance<-1 && key < node->right->key){
        node->right=RR(node->right);
        return LL(node);
    }
    return node ;
}


Node * AVL::minValueNode(Node * node){

    Node * current= node ;
    while (current->left!=NULL){
        current= current->left;
    }
    return current;
}

Node * AVL::deleteNode(Node * r , int key ){
    if (r == NULL){
        qDebug()<<"base";
        return r;
    }
    if (key < r->key){
        qDebug()<<"less";
        r->left=deleteNode(r->left,key);
    }else if (key>r->key){
        qDebug()<<"greater";
        r->right= deleteNode(r->right,key);
    }else{
        qDebug()<<"esle";
        if ((r->left==NULL) || (r->right==NULL)){
            Node * tmp = new Node ;
            qDebug()<<"if";
            tmp = r->left ? r->left : r->right;
            qDebug()<<"bad tmo ";
            if (tmp = NULL){
                tmp= r ;
                r =NULL;

            }else{
                qDebug()<<"eslsse 2";
                r = tmp ;

            }
            delete(tmp);
        }else{
            Node * tmp = new Node ;
            tmp = minValueNode(r->right);
            r->key=tmp->key;
            r->right = deleteNode(r->right,tmp->key);
        }
    }
    if (r==NULL){
        return r ;
    }
    r->height= qMax(height(r->left),height(r->right))+1;

    int balance ;
    balance= getBalance(r);



    if (balance > 1 && getBalance(r->left) >= 0)
          return RR(r);

      if (balance > 1 && getBalance(r->left) < 0)
      {
          r->left =  LL(r->left);
          return RR(r);
      }

      if (balance < -1 && getBalance(r->right) <= 0)
          return LL(r);

      if (balance < -1 && getBalance(r->right) > 0)
      {
          r->right = RR(r->right);
          return LL(r);
      }

      return r;
}

void AVL::preorder(Node *node ){

    if (node!= NULL){
       qDebug()<<node->key;
       preorder(node->left);
       preorder(node->right);
    }

}
