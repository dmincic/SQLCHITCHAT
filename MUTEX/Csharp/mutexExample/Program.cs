using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
using System.Threading;
//using System.Threading.Tasks;

namespace mutexExample
{
    class Program
    {
        public static Mutex m = new Mutex();
  
        static void Main(string[] args)
        {

            ThreadSafeDivide testThreadSafeDivide = new ThreadSafeDivide();

            //create threads
            Thread[] Threads = new Thread[3];
            for (int i = 0; i < 3; i++)
            {
                Threads[i] = new Thread(new ThreadStart(testThreadSafeDivide.DivideNumbers));
                Threads[i].Name = "ChildThread " + i;

            }
            //start all 3 threads;
            foreach (Thread t in Threads)
            {
                t.Start();
            }

        }
        class ThreadSafeDivide
        {
            int num1 = 0;
            int num2 = 0;
            float result = 0;
            Random rndNum = new Random(); //generates random numbers

            public void DivideNumbers()
            {

               // m.WaitOne();
                for (int i = 0; i < 5; i++)
                {
                   
                        num1 = rndNum.Next(1, 5); //min value 1, max value 5
                        num2 = rndNum.Next(1, 5);

                    Console.WriteLine("Execution No: " + i + " Current Thread Name:" + Thread.CurrentThread.Name + "; Numbers to divide: " + num1 + "/" + num2);
                    result = (num1 / num2);

                    num2 = 0;
                    Thread.Sleep(10);
                    num1 = 0;
                  
                }
                //m.ReleaseMutex();
                Console.WriteLine(Thread.CurrentThread.Name + " has finished processing");

                Console.WriteLine("Press any key to exit");
                Console.ReadLine();//wait for user to press ENTER
            }
            
        }       
    }
}
