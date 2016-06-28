#include <stdlib.h>

// Функция для рассчета расстояния от точки до отрезка
double GetSegDist(double x,double y,double x1,double y1,double x2,double y2){
  double v=(x-x1)*(y2-y1)-(y-y1)*(x2-x1);
  return v*v/((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));
}

unsigned int * CompressChart(double Data[], unsigned int count, double epsilon)
{
  int i, j;
  unsigned int *KeepPoint = malloc(sizeof(unsigned int) * count);
  for (i = 0; i < count; i++)
  {
    KeepPoint[i] = 1;
  }
  int LeftInd[count / 2];
  int RightInd[count / 2];
  int intervals = 0;
  //+ init
  LeftInd[intervals] = 0;
  RightInd[intervals] = count - 1;
  intervals++;
  double Max = Data[0];
  double Min = Data[0];
  for (i = 0; i < count; i++)
  {
    double v = Data[i];
    if (v < Min) Min = v;
    else if (v > Max) Max = v;
  }
  epsilon = (Max - Min) * epsilon;
  epsilon = epsilon * epsilon;
  //-
  //+ Основной цикл
  while (intervals > 0)
  {
    intervals--;
    int Start = LeftInd[intervals];
    int End = RightInd[intervals];
    double dMax = 0;
    int index = Start;
    for (i = Start + 1; i < End; i++)
    {
      if (KeepPoint[i] == 1)
      {
        double d = GetSegDist(i, Data[i], Start, Data[Start], End, Data[End]);
        if (d > dMax)
        {
          index = i;
          dMax = d;
        }
      }
    }
    if (dMax >= epsilon)
    {
      LeftInd[intervals] = Start;
      RightInd[intervals] = index;
      intervals++;
      LeftInd[intervals] = index;
      RightInd[intervals] = End;
      intervals++;
    }
    else{
      for (j = Start + 1; j < End; j++)
      {
        KeepPoint[j] = 0;
      }
    }
  }
  //-
  return KeepPoint;
}
