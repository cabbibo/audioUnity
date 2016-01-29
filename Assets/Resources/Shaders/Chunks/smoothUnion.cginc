float2 smoothUnion( float2 shape1, float2 shape2, float smoothingSize ){

    float distance1 = shape1.x;
    float distance2 = shape2.x;
    float smoothingVal = clamp( 0.5 + 0.5 * ( distance2 - distance1 ) / smoothingSize , 0.0 , 1.0);

    // smoothing 
    float extraSmoooth = smoothingSize * smoothingVal * ( 1.0 - smoothingVal );
    float finalDistance = lerp( distance2 , distance1 , smoothingVal ) - extraSmoooth;
    float finalID = lerp( shape2.y , shape1.y , pow( smoothingVal , 2.0 ) );

    return float2( finalDistance , finalID );

}