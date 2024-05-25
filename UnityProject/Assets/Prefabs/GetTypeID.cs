using System;
using System.Collections;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Security.Policy;
using System.Text;
using UnityEngine;
// using HashDepot;

public class GetTypeID : MonoBehaviour
{
    [SerializeField] private GameObject prefab;
    void Start()
    {
        Type type = prefab.GetType();
        Debug.Log("Namespace: " + type.Namespace + " , Name: " + type.Name);
    }
}


