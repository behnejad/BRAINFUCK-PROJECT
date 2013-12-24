#include "node.h"

Node::Node()
{

}
Node::Node(int key)
{
       this->k= key;
       Node->left   = NULL;
       Node->right  = NULL;
       Node->height = 1;  // new node is initially added at leaf
}
