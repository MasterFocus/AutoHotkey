// Original C code for Gdip_ImageSearch()
// by tic and Rseding91
// http://www.autohotkey.com/board/topic/71100-gdip-imagesearch/?p=527765

int Gdip_ImageSearch1(int * Foundx, int * Foundy, unsigned char * HayStack, unsigned char * Needle, int nw, int nh, int Stride1, int Stride2, int sx1, int sy1, int sx2, int sy2, unsigned char * Trans, int v, int sd, int suX, int suY)
{
	int y1, y2, x1, x2, tx, ty;
	
	if (Trans[0] || Trans[1] || Trans[2])
	{
		for (y1 = 0; y1 < nh; y1++)
		{
			for (x1 = 0; x1 < nw; x1++)
			{
				if (Needle[(4*x1)+(y1*Stride2)+2] == Trans[2]
				&& Needle[(4*x1)+(y1*Stride2)+1] == Trans[1]
				&& Needle[(4*x1)+(y1*Stride2)] == Trans[0])
					Needle[(4*x1)+(y1*Stride2)+3] = 0;
			}
		}
	}
	
	for (y1 = sy1; y1 < sy2; y1++)
	{
		for (x1 = sx1; x1 < sx2; x1++)
		{
			if (sd == 1){
				ty = y1;
				for (y2 = 0; y2 < nh; y2++)
				{
					tx = x1;
					for (x2 = 0; x2 < nw; x2++)
					{
						if (Needle[(4*x2)+(y2*Stride2)+2] == HayStack[(4*tx)+(ty*Stride1)+2]
						&& Needle[(4*x2)+(y2*Stride2)+1] == HayStack[(4*tx)+(ty*Stride1)+1]
						&& Needle[(4*x2)+(y2*Stride2)] == HayStack[(4*tx)+(ty*Stride1)]
						|| Needle[(4*x2)+(y2*Stride2)+3] == 0)
							tx++;
						else
							goto NoMatch;
					}
					ty++;
				}
			} else if (sd == 2){
				ty = y1 + nh - 1;
				for (y2 = nh - 1; y2 > -1; y2--)
				{
					tx = x1;
					for (x2 = 0; x2 < nw; x2++)
					{
						if (Needle[(4*x2)+(y2*Stride2)+2] == HayStack[(4*tx)+(ty*Stride1)+2]
						&& Needle[(4*x2)+(y2*Stride2)+1] == HayStack[(4*tx)+(ty*Stride1)+1]
						&& Needle[(4*x2)+(y2*Stride2)] == HayStack[(4*tx)+(ty*Stride1)]
						|| Needle[(4*x2)+(y2*Stride2)+3] == 0)
							tx++;
						else
							goto NoMatch;
					}
					ty--;
				}
			} else if (sd == 3){
				ty = y1 + nh - 1;
				for (y2 = nh - 1; y2 > -1; y2--)
				{
					tx = x1 + nw - 1;
					for (x2 = nw - 1; x2 > -1; x2--)
					{
						if (Needle[(4*x2)+(y2*Stride2)+2] == HayStack[(4*tx)+(ty*Stride1)+2]
						&& Needle[(4*x2)+(y2*Stride2)+1] == HayStack[(4*tx)+(ty*Stride1)+1]
						&& Needle[(4*x2)+(y2*Stride2)] == HayStack[(4*tx)+(ty*Stride1)]
						|| Needle[(4*x2)+(y2*Stride2)+3] == 0)
							tx--;
						else
							goto NoMatch;
					}
					ty--;
				}
			} else if (sd == 4){
				ty = y1;
				for (y2 = 0; y2 < nh; y2++)
				{
					tx = x1 + nw - 1;
					for (x2 = nw - 1; x2 > -1; x2--)
					{
						if (Needle[(4*x2)+(y2*Stride2)+2] == HayStack[(4*tx)+(ty*Stride1)+2]
						&& Needle[(4*x2)+(y2*Stride2)+1] == HayStack[(4*tx)+(ty*Stride1)+1]
						&& Needle[(4*x2)+(y2*Stride2)] == HayStack[(4*tx)+(ty*Stride1)]
						|| Needle[(4*x2)+(y2*Stride2)+3] == 0)
							tx--;
						else
							goto NoMatch;
					}
					ty++;
				}
			}
			
			Foundx[0] = x1; Foundy[0] = y1;
			return 0;
			NoMatch:;
		}
	}
	
	Foundx[0] = -1; Foundy[0] = -1;
	return -1;
}

int Gdip_ImageSearch2(int * Foundx, int * Foundy, unsigned char * HayStack, unsigned char * Needle, int nw, int nh, int Stride1, int Stride2, int sx1, int sy1, int sx2, int sy2, unsigned char * Trans, int v, int sd, int suX, int suY)
{
	int y1, y2, x1, x2, tx, ty;
	
	if (Trans[0] || Trans[1] || Trans[2])
	{
		for (y1 = 0; y1 < nh; y1++)
		{
			for (x1 = 0; x1 < nw; x1++)
			{
				if (Needle[(4*x1)+(y1*Stride2)+2] == Trans[2]
				&& Needle[(4*x1)+(y1*Stride2)+1] == Trans[1]
				&& Needle[(4*x1)+(y1*Stride2)] == Trans[0])
					Needle[(4*x1)+(y1*Stride2)+3] = 0;
			}
		}
	}
	
	for (y1 = sy1; y1 < sy2; y1++)
	{
		for (x1 = sx1; x1 < sx2; x1++)
		{
			if (Needle[(4*suX)+(suY*Stride2)] <= HayStack[(4*(x1 + suX))+((y1 + suY)*Stride1)]+v
			&& Needle[(4*suX)+(suY*Stride2)] >= HayStack[(4*(x1 + suX))+((y1 + suY)*Stride1)]-v
			|| Needle[(4*suX)+(suY*Stride2)+3] == 0)
			{
				if (sd == 1){
					ty = y1;
					for (y2 = 0; y2 < nh; y2++)
					{
						tx = x1;
						for (x2 = 0; x2 < nw; x2++)
						{
							if (Needle[(4*x2)+(y2*Stride2)+2] <= HayStack[(4*tx)+(ty*Stride1)+2]+v
							&& Needle[(4*x2)+(y2*Stride2)+2] >= HayStack[(4*tx)+(ty*Stride1)+2]-v
							&& Needle[(4*x2)+(y2*Stride2)+1] <= HayStack[(4*tx)+(ty*Stride1)+1]+v
							&& Needle[(4*x2)+(y2*Stride2)+1] >= HayStack[(4*tx)+(ty*Stride1)+1]-v
							&& Needle[(4*x2)+(y2*Stride2)] <= HayStack[(4*tx)+(ty*Stride1)]+v
							&& Needle[(4*x2)+(y2*Stride2)] >= HayStack[(4*tx)+(ty*Stride1)]-v
							|| Needle[(4*x2)+(y2*Stride2)+3] == 0)
								tx++;
							else
								goto NoMatch;
						}
						ty++;
					}
				} else if (sd == 2){
					ty = y1 + nh - 1;
					for (y2 = nh - 1; y2 > -1; y2--)
					{
						tx = x1;
						for (x2 = 0; x2 < nw; x2++)
						{
							if (Needle[(4*x2)+(y2*Stride2)+2] <= HayStack[(4*tx)+(ty*Stride1)+2]+v
							&& Needle[(4*x2)+(y2*Stride2)+2] >= HayStack[(4*tx)+(ty*Stride1)+2]-v
							&& Needle[(4*x2)+(y2*Stride2)+1] <= HayStack[(4*tx)+(ty*Stride1)+1]+v
							&& Needle[(4*x2)+(y2*Stride2)+1] >= HayStack[(4*tx)+(ty*Stride1)+1]-v
							&& Needle[(4*x2)+(y2*Stride2)] <= HayStack[(4*tx)+(ty*Stride1)]+v
							&& Needle[(4*x2)+(y2*Stride2)] >= HayStack[(4*tx)+(ty*Stride1)]-v
							|| Needle[(4*x2)+(y2*Stride2)+3] == 0)
								tx++;
							else
								goto NoMatch;
						}
						ty--;
					}
				} else if (sd == 3){
					ty = y1 + nh - 1;
					for (y2 = nh - 1; y2 > -1; y2--)
					{
						tx = x1 + nw - 1;
						for (x2 = nw - 1; x2 > -1; x2--)
						{
							if (Needle[(4*x2)+(y2*Stride2)+2] <= HayStack[(4*tx)+(ty*Stride1)+2]+v
							&& Needle[(4*x2)+(y2*Stride2)+2] >= HayStack[(4*tx)+(ty*Stride1)+2]-v
							&& Needle[(4*x2)+(y2*Stride2)+1] <= HayStack[(4*tx)+(ty*Stride1)+1]+v
							&& Needle[(4*x2)+(y2*Stride2)+1] >= HayStack[(4*tx)+(ty*Stride1)+1]-v
							&& Needle[(4*x2)+(y2*Stride2)] <= HayStack[(4*tx)+(ty*Stride1)]+v
							&& Needle[(4*x2)+(y2*Stride2)] >= HayStack[(4*tx)+(ty*Stride1)]-v
							|| Needle[(4*x2)+(y2*Stride2)+3] == 0)
								tx--;
							else
								goto NoMatch;
						}
						ty--;
					}
				} else if (sd == 4){
					ty = y1;
					for (y2 = 0; y2 < nh; y2++)
					{
						tx = x1 + nw - 1;
						for (x2 = nw - 1; x2 > -1; x2--)
						{
							if (Needle[(4*x2)+(y2*Stride2)+2] <= HayStack[(4*tx)+(ty*Stride1)+2]+v
							&& Needle[(4*x2)+(y2*Stride2)+2] >= HayStack[(4*tx)+(ty*Stride1)+2]-v
							&& Needle[(4*x2)+(y2*Stride2)+1] <= HayStack[(4*tx)+(ty*Stride1)+1]+v
							&& Needle[(4*x2)+(y2*Stride2)+1] >= HayStack[(4*tx)+(ty*Stride1)+1]-v
							&& Needle[(4*x2)+(y2*Stride2)] <= HayStack[(4*tx)+(ty*Stride1)]+v
							&& Needle[(4*x2)+(y2*Stride2)] >= HayStack[(4*tx)+(ty*Stride1)]-v
							|| Needle[(4*x2)+(y2*Stride2)+3] == 0)
								tx--;
							else
								goto NoMatch;
						}
						ty++;
					}
				}
			} else
				continue;
			
			Foundx[0] = x1; Foundy[0] = y1;
			return 0;
			NoMatch:;
		}
	}
	
	Foundx[0] = -1; Foundy[0] = -1;
	return -1;
}

int PixelAverageScan(unsigned char * Needle, int Stride, int w, int h, int * Temp, int * suX, int * suY)
{
	unsigned int R, G, B;
	int x, y, tx, ty;
	int RL, GL, BL;
	int RH, GH, BH;
	int Count, Corner;
	int ScanDirection = 0;
	int LastDifference, LastCount;
	int LargestCount = 0;
	int * SX, * SY, * SW, * SH;
	
	suX[0] = 0;
	suY[0] = 0;
	
	SX = Temp;
	SY = SX + 5;
	SW = SY + 5;
	SH = SW + 5;
	
	SW[1] = w / 2;
	SH[1] = h / 2;
	
	SY[2] = h / 2;
	SW[2] = w / 2;
	SH[2] = h;
	
	SX[3] = w / 2;
	SY[3] = h / 2;
	SW[3] = w;
	SH[3] = h;
	
	SX[4] = w / 2;
	SW[4] = w;
	SH[4] = h / 2;
	
	//The maximum possible safe image size is 67371264 total pixels
	//Larger images can be used but they may give false average color readings
	for (Corner = 1; Corner < 5; Corner++)
	{
		R = 0;
		G = 0;
		B = 0;
		for (y = SY[Corner]; y < SH[Corner]; y++)
		{
			for (x = SX[Corner]; x < SW[Corner]; x++)
			{
				R += Needle[(4*x)+(y*Stride)+2];
				G += Needle[(4*x)+(y*Stride)+1];
				B += Needle[(4*x)+(y*Stride)];
			}
		}
		
		R = R / ((SW[Corner] - SX[Corner]) * (SH[Corner] - SY[Corner]));
		G = G / ((SW[Corner] - SX[Corner]) * (SH[Corner] - SY[Corner]));
		B = B / ((SW[Corner] - SX[Corner]) * (SH[Corner] - SY[Corner]));
		
		RH = R + 25;
		RL = R - 25;
		GH = G + 25;
		GL = G - 25;
		BH = B + 25;
		BL = B - 25;
		
		Count = 0;
		LastDifference = 0;
		for (y = SY[Corner]; y < SH[Corner]; y++)
		{
			for (x = SX[Corner]; x < SW[Corner]; x++)
			{
				if (Needle[(4*x)+(y*Stride)+3] == 0)
					continue;
				
				LastCount = Count;
				
				if (Needle[(4*x)+(y*Stride)+2] >= RH || Needle[(4*x)+(y*Stride)+2] <= RL)
					Count ++;
				
				if (Needle[(4*x)+(y*Stride)+1] >= GH || Needle[(4*x)+(y*Stride)+1] <= GL)
					Count ++;
				
				if (Needle[(4*x)+(y*Stride)] >= BH || Needle[(4*x)+(y*Stride)] <= BL)
					Count ++;
				
				
				if ((Count - LastCount) > LastDifference)
				{
					tx = x;
					ty = y;
					LastDifference = Count - LastCount;
				}
			}
		}
		
		if (Count > LargestCount)
		{
			LargestCount = Count;
			ScanDirection = Corner;
			suX[0] = tx;
			suY[0] = ty;
		}
	}
	
	return ScanDirection;
}