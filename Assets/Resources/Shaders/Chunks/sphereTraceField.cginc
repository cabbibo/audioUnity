float2 sphereTraceField( in float3 rayOrigin , in float3 rayDirection ){     
            
    float radiusOfSphere =  _IntersectionPrecision * 2;
    float totalDistance  = 0.0;
    float finalDistance = -1.0;
    float id = -1.0;

    for( int i = 0 ; i < _NumberSteps; i++ ){
        
        if( radiusOfSphere < _IntersectionPrecision || 
            totalDistance  > _MaxTraceDistance 
          ) break;

        float3 position = rayOrigin + rayDirection * totalDistance;
        float2 fieldValue = map( position );
        
        radiusOfSphere = fieldValue.x;
        totalDistance += radiusOfSphere;
        id = fieldValue.y;
        
    }


    if( totalDistance <  _MaxTraceDistance ){ finalDistance = totalDistance; }
    if( totalDistance >  _MaxTraceDistance ){ id = -1.0; }

    return float2( finalDistance , id );
      

}
            