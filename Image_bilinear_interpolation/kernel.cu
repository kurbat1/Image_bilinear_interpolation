#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

#include <iostream>
#include <string>
#include <stdio.h>
#include <math.h>

using namespace cv;
using namespace std;

int main()
{

	Mat img, dst;
	float tmp1 = 0, tmp2 = 0, d1, d2;
	int cnt = 0;

	img = imread("./input/sword.png");
	dst = Mat::zeros(512, 512, img.type());
	//768

	for (int i = 0; i < img.rows; i++) {
		for (int j = 0; j < img.cols; j++) {
			for (int k = 0; k < 3; k++) {
				dst.at<Vec3b>(i * 1.5, j * 1.5)[k] = img.at<Vec3b>(i, j)[k];

			}
		}
	}

	for (int i = 1; i < dst.rows - 1; i++) {
		for (int j = 1; j < dst.cols - 1; j++) {
			for (int k = 0; k < 3; k++) {
				if (dst.at<Vec3b>(i, j)[k] == 0) { // (i-move vertically, j-move horizontally)

					for (int s = 1; s < dst.rows - 1; s++) { // First we look for pixels left and right, and take those two values if there are
						if (i - s >= 0 && i + s <= dst.rows - 1) {
							if (dst.at<Vec3b>(i - s, j)[k] != 0) { // Check left pixel
								if (tmp1 == 0) {
									tmp1 = dst.at<Vec3b>(i - s, j)[k];
									d1 = s;
								}
							}
							if (dst.at<Vec3b>(i + s, j)[k] != 0) { // Check right pixel
								if (tmp2 == 0) {
									tmp2 = dst.at<Vec3b>(i + s, j)[k];
									d2 = s;
								}
							}
						}
						if (tmp1 != 0 && tmp2 != 0) { // Weighted by the percentage of distance away when all the left and right pixel values are found
							dst.at<Vec3b>(i, j)[k] = tmp1 * (d2 / (d1 + d2)) + tmp2 * (d1 / (d1 + d2));
							tmp1 = 0;
							tmp2 = 0;
							printf("%d / CHECK Running...\n", cnt++);
							break; // No need to find anymore, go to next line
						}
					}
				}

			}
		}
	}

	tmp1 = 0;
	tmp2 = 0;

	for (int i = 1; i < dst.rows - 1; i++) { // This time using the value found above on the line with no pixels left and right
											 // Find neighboring pixels up and down and fill the empty pixels as above
		for (int j = 1; j < dst.cols - 1; j++) {
			for (int k = 0; k < 3; k++) {
				if (dst.at<Vec3b>(i, j)[k] == 0) {

					for (int s = 1; s < dst.rows - 1; s++) {
						if (j - s >= 0 && j + s <= dst.rows - 1) {
							if (dst.at<Vec3b>(i, j - s)[k] != 0) { // Upward direction search
								if (tmp1 == 0) {
									tmp1 = dst.at<Vec3b>(i, j - s)[k];
									d1 = s;
								}
							}
							if (dst.at<Vec3b>(i, j + s)[k] != 0) { // Downward Search
								if (tmp2 == 0) {
									tmp2 = dst.at<Vec3b>(i, j + s)[k];
									d2 = s;
								}
							}
						}
						if (tmp1 != 0 && tmp2 != 0) { // When both neighboring pixels are found, weighted and filled with blank pixels
							printf("%d / 976904 RRUNNING...\n", cnt++);
							dst.at<Vec3b>(i, j)[k] = tmp1 * (d2 / (d1 + d2)) + tmp2 * (d1 / (d1 + d2));
							tmp1 = 0;
							tmp2 = 0;
							break;
						}
					}
				}

			}
		}
	}

	imshow("Original", img);
	imshow("Result", dst);

	waitKey(0);
	return 0;

}